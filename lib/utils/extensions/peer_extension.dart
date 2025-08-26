import 'package:logging/logging.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus_sdk/constants/rtc_config.dart' show RtcConfig;

final _logger = Logger('PeerExtension');

extension PeerExtension on RTCPeerConnection {
  Future<RTCRtpSender> addSimulcastTrack(
    MediaStreamTrack track, {
    required RTCVideoCodec vCodec,
    required MediaStream stream,
    RtcTrackKind kind = RtcTrackKind.video,
    required bool isSingleTrack,
  }) async {
    final List<RTCRtpEncoding> encodings = [];

    if (kind == RtcTrackKind.video && !isSingleTrack) {
      if (vCodec == RTCVideoCodec.vp9) {
        encodings.addAll(RtcConfig.svcEncodings);
      } else {
        encodings.addAll(RtcConfig.simulcastEncodings);
      }
    }

    final transceiver = await addTransceiver(
      track: track,
      kind: kind == RtcTrackKind.video
          ? RTCRtpMediaType.RTCRtpMediaTypeVideo
          : RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendOnly,
        streams: [stream],
        sendEncodings: encodings.isEmpty ? null : encodings,
      ),
    );

    final sender = transceiver.sender;

    if (kind != RtcTrackKind.video) return sender;

    await _setPreferredCodec(transceiver, kind, vCodec.codec);

    return sender;
  }

  Future<void> _setPreferredCodec(
    RTCRtpTransceiver transceiver,
    RtcTrackKind kind,
    String videoCodec,
  ) async {
    // when setting codec preferences, the capabilites need to be read from
    // the RTCRtpReceiver
    final caps = await getRtpReceiverCapabilities(kind.kind);
    if (caps.codecs == null) return;

    _logger.fine('get capabilities ${caps.codecs}');

    final List<RTCRtpCodecCapability> matched = [];
    final List<RTCRtpCodecCapability> partialMatched = [];
    final List<RTCRtpCodecCapability> unmatched = [];
    for (final c in caps.codecs!) {
      final codec = c.mimeType.toLowerCase();
      if (codec == 'audio/opus') {
        matched.add(c);
        continue;
      }

      final matchesVideoCodec = codec == 'video/$videoCodec';
      if (!matchesVideoCodec) {
        if (WebRTC.platformIsAndroid && codec == 'video/vp9') {
          if (c.sdpFmtpLine != null &&
              (c.sdpFmtpLine!.contains('profile-id=0') ||
                  c.sdpFmtpLine!.contains('profile-id=1'))) {
            unmatched.add(c);
          }
        } else {
          unmatched.add(c);
        }
        continue;
      }
      // for h264 codecs that have sdpFmtpLine available, use only if the
      // profile-level-id is 42e01f for cross-browser compatibility
      if (videoCodec.toLowerCase() == 'h264') {
        if (c.sdpFmtpLine != null &&
            c.sdpFmtpLine!.contains('profile-level-id=42e01f')) {
          matched.add(c);
        } else {
          partialMatched.add(c);
        }
        continue;
      }
      if (WebRTC.platformIsAndroid && codec == 'video/vp9') {
        if (c.sdpFmtpLine != null &&
            (c.sdpFmtpLine!.contains('profile-id=0') ||
                c.sdpFmtpLine!.contains('profile-id=1'))) {
          matched.add(c);
        }
      } else {
        matched.add(c);
      }
    }

    matched.addAll([...partialMatched, ...unmatched]);
    try {
      await transceiver.setCodecPreferences(matched);
    } catch (e) {
      _logger.warning('setCodecPreferences failed: $e');
    }
  }

  Future<RTCDataChannel> createDefaultChannel() async {
    final channelInit = RTCDataChannelInit()
      ..ordered = true
      ..binaryType = 'binary'
      ..maxRetransmits = 30;

    final channel = await createDataChannel(
      "waterbus/rtc/channel",
      channelInit,
    );

    return channel;
  }
}

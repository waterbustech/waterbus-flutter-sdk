import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

import 'package:waterbus_sdk/constants/rtc_configurations.dart'
    show RTCConfigurations;

extension PeerX on RTCPeerConnection {
  Future<RTCRtpSender> addSimulcastTrack(
    MediaStreamTrack track, {
    required RTCVideoCodec vCodec,
    required MediaStream stream,
    RtcTrackKind kind = RtcTrackKind.video,
    required bool isSingleTrack,
  }) async {
    final List<RTCRtpEncoding> encodings = [];

    if (kind == RtcTrackKind.video) {
      if (vCodec == RTCVideoCodec.vp9) {
        encodings.addAll(RTCConfigurations.svcEncodings);
      } else {
        encodings.addAll(RTCConfigurations.simulcastEncodings);
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
        sendEncodings: encodings,
      ),
    );

    final sender = transceiver.sender;

    if (kind != RtcTrackKind.video) return sender;

    await _setPreferredCodec(
      transceiver: transceiver,
      vCodec: vCodec.codec,
      kind: kind,
    );

    return sender;
  }

  Future<void> _setPreferredCodec({
    required RTCRtpTransceiver transceiver,
    required RtcTrackKind kind,
    required String vCodec,
  }) async {
    final caps = await getRtpReceiverCapabilities(kind.kind);
    if (caps.codecs == null) return;

    final List<RTCRtpCodecCapability> matched = [];
    final List<RTCRtpCodecCapability> partialMatched = [];
    final List<RTCRtpCodecCapability> unmatched = [];
    for (final c in caps.codecs!) {
      final codec = c.mimeType.toLowerCase();
      if (codec == 'audio/opus') {
        matched.add(c);
        continue;
      }

      final matchesVideoCodec =
          codec.toLowerCase() == 'video/$vCodec'.toLowerCase();
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
      if (vCodec.toLowerCase() == 'h264') {
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
      WaterbusLogger.instance.bug('setCodecPreferences failed: $e');
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:waterbus_sdk/constants/webrtc_configurations.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';
import 'package:waterbus_sdk/types/models/audio_stats_params.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

extension PeerX on RTCPeerConnection {
  Future<void> addSimulcastTrack(
    MediaStreamTrack track, {
    required WebRTCCodec vCodec,
    required MediaStream stream,
    String kind = 'video',
    bool skipSetPreferredCodec = false,
    bool simulcast = true,
  }) async {
    final transceiver = await addTransceiver(
      track: track,
      kind: kind == 'video'
          ? RTCRtpMediaType.RTCRtpMediaTypeVideo
          : RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendOnly,
        streams: [stream],
        sendEncodings:
            kind == 'video' ? WebRTCConfigurations.videoEncodings : [],
      ),
    );

    if (kind != 'video') return;

    await Future.wait([
      _setPreferredCodec(
        transceiver: transceiver,
        vCodec: vCodec.codec,
        kind: kind,
      ),
      _updateParameters(sender: transceiver.sender),
    ]);
  }

  void monitorStats(
    WebRTCVideoStats stats, {
    required WebRTCAudioStats audioStats,
    required Function(AudioLevel) onLevelChanged,
    required String id,
    required bool isMe,
  }) {
    onIceConnectionState = (state) async {
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
          if (isMe) {
            final senders = await getSenders();
            stats.addSenders(id, senders);

            audioStats.setSender = AudioStatsParams(
              peerConnection: this,
              callBack: onLevelChanged,
            );
          } else {
            final receivers = await getReceivers();
            stats.addReceivers(id, receivers);

            audioStats.addReceiver(
              AudioStatsParams(
                peerConnection: this,
                callBack: onLevelChanged,
                receivers: receivers,
              ),
            );
          }

          break;
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          if (isMe) {
            stats.removeSenders();
            audioStats.setSender = null;
          } else {
            stats.removeReceivers(id);
            audioStats.removeReceiver(peerConnectionId);
          }
          break;
        default:
          break;
      }
    };
  }

  Future<void> _setPreferredCodec({
    required RTCRtpTransceiver transceiver,
    required String kind,
    required String vCodec,
  }) async {
    // when setting codec preferences, the capabilites need to be read from
    // the RTCRtpReceiver
    final caps = await getRtpReceiverCapabilities(kind);
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
        unmatched.add(c);
        continue;
      }
      // for h264 codecs that have sdpFmtpLine available, use only if the
      // profile-level-id is 42e01f for cross-browser compatibility
      if (vCodec.toLowerCase() == 'h264') {
        if (c.sdpFmtpLine != null &&
            (c.sdpFmtpLine!.contains('profile-level-id=42e01f'))) {
          matched.add(c);
        } else {
          partialMatched.add(c);
        }
        continue;
      }
      matched.add(c);
    }
    matched.addAll([...partialMatched, ...unmatched]);
    try {
      await transceiver.setCodecPreferences(matched);
    } catch (e) {
      WaterbusLogger.instance.bug('setCodecPreferences failed: $e');
    }
  }

  Future<void> _updateParameters({
    required RTCRtpSender sender,
  }) async {
    if (kIsWeb) return;

    final parameters = sender.parameters;
    parameters.degradationPreference =
        RTCDegradationPreference.MAINTAIN_RESOLUTION;

    await sender.setParameters(parameters);
  }
}

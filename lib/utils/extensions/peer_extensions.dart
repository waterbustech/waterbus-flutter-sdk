import 'package:flutter/foundation.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';
import 'package:waterbus_sdk/types/models/audio_stats_params.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

extension PeerX on RTCPeerConnection {
  Future<void> createScreenSharingTrack(
    MediaStreamTrack track, {
    required WebRTCCodec vCodec,
    required MediaStream stream,
    String kind = 'video',
  }) async {
    final transceiver = await addTransceiver(
      track: track,
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendOnly,
        streams: [stream],
      ),
    );

    if (!kIsWeb) return;

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
          codec.toLowerCase() == 'video/${vCodec.codec}'.toLowerCase();
      if (!matchesVideoCodec) {
        unmatched.add(c);
        continue;
      }
      // for h264 codecs that have sdpFmtpLine available, use only if the
      // profile-level-id is 42e01f for cross-browser compatibility
      if (vCodec.codec == 'h264') {
        if (c.sdpFmtpLine != null &&
            c.sdpFmtpLine!.contains('profile-level-id=42e01f')) {
          matched.add(c);
        } else {
          partialMatched.add(c);
        }
        continue;
      }
      matched.add(c);
    }
    matched.addAll([...partialMatched]);
    try {
      await transceiver.setCodecPreferences(matched);
    } catch (e) {
      WaterbusLogger.instance.bug('setCodecPreferences failed: $e');
    }
  }

  void setMaxBandwidth(int? bandwidth) {
    senders.then((senders) {
      for (final sender in senders) {
        final parameters = sender.parameters;
        var encodings = parameters.encodings;

        if (encodings == null || encodings.isEmpty) {
          encodings = List.of([RTCRtpEncoding()]);
        }

        for (final encoding in encodings) {
          if (bandwidth == null || bandwidth == 0) {
            encoding.maxBitrate = null;
          } else {
            encoding.maxBitrate = bandwidth * 1000;
          }
        }

        parameters.encodings = encodings;
        sender.setParameters(parameters);
      }
    });
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
}

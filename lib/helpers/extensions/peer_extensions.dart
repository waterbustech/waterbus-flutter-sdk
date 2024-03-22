// Package imports:
import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

// Project imports:
import 'package:waterbus_sdk/helpers/stats/webrtc_audio_stats.dart';
import 'package:waterbus_sdk/helpers/stats/webrtc_video_stats.dart';
import 'package:waterbus_sdk/models/audio_stats_params.dart';
import 'package:waterbus_sdk/models/enums/audio_level.dart';

extension PeerX on RTCPeerConnection {
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
            stats.removeSenders(id);
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

import 'dart:async';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@singleton
class WebRTCAudioStats {
  final List<AudioStatsParams> _receivers = [];
  AudioStatsParams? _sender;
  Timer? _timer;

  set setSender(AudioStatsParams? param) {
    _sender = param;
  }

  void addReceiver({
    required String ownerId,
    required RTCRtpReceiver receiver,
    required Function(AudioLevel) callback,
  }) {
    final int index = _receivers.indexWhere(
      (params) => params.ownerId == ownerId,
    );

    if (index < 0) {
      _receivers.add(
        AudioStatsParams(
          ownerId: ownerId,
          callBack: callback,
          receivers: [receiver],
        ),
      );
    } else {
      _receivers[index] = _receivers[index].copyWith(
        receivers: [receiver],
        callBack: callback,
      );
    }
  }

  void removeReceiver(String ownerId) {
    final int index = _receivers.indexWhere(
      (params) => params.ownerId == ownerId,
    );

    if (index < 0) return;
    _receivers.removeAt(index);
  }

  void initialize() {
    _timer ??= Timer.periodic(1.seconds, (timer) {
      if (_sender != null) {
        _monitorAudio(params: _sender!);
      }

      // Create a copy to avoid concurrent modification
      final receiversCopy = List<AudioStatsParams>.from(_receivers);
      for (final params in receiversCopy) {
        _monitorAudio(params: params, type: 'inbound-rtp');
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _sender = null;
    _receivers.clear();
  }

  // MARK: private
  Future<void> _monitorAudio({
    required AudioStatsParams params,
    String type = 'media-source',
  }) async {
    try {
      final List<StatsReport> stats = [];

      if (type == 'media-source') {
        if (params.pc == null) return;

        if (params.pc!.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
            params.pc!.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          return;
        }

        final List<RTCRtpSender> senders = (await params.pc!.getSenders())
            .where((sender) => sender.track?.kind == 'audio')
            .toList();

        for (final rtpSender in senders) {
          try {
            final senderStats = await rtpSender.getStats();
            stats.addAll(senderStats);
          } catch (e) {
            continue;
          }
        }
      } else {
        final List<RTCRtpReceiver> rtpReceivers = params.receivers;
        for (final rtpReceiver in rtpReceivers) {
          try {
            final receiverStats = await rtpReceiver.getStats();
            stats.addAll(receiverStats);
          } catch (e) {
            continue;
          }
        }
      }

      for (final v in stats) {
        if (v.type == type && v.values['kind'] == 'audio') {
          final num? audioLevel = getNumValFromReport(v.values, 'audioLevel');
          if (audioLevel == null) continue;

          try {
            params.callBack(audioLevel.level);
          } catch (e) {
            continue;
          }
        }
      }
    } catch (error) {
      WaterbusLogger.instance.bug('Error in _monitorAudio: $error');
    }
  }
}

import 'dart:async';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

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
      if (_sender != null) _monitorAudio(params: _sender!);

      for (final params in _receivers) {
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
    final List<StatsReport> stats = [];

    if (type == 'media-source') {
      if (params.pc == null) return;
      final List<StatsReport> senderStats = await params.pc!.getStats();
      stats.addAll(senderStats);
    } else {
      final List<RTCRtpReceiver> rtpReceivers = params.receivers;

      for (final rtpReceiver in rtpReceivers) {
        final receiverStats = await rtpReceiver.getStats();
        stats.addAll(receiverStats);
      }
    }

    for (final v in stats) {
      if (v.type == type && v.values['kind'] == 'audio') {
        final num? audioLevel = getNumValFromReport(v.values, 'audioLevel');

        if (audioLevel == null) return;

        params.callBack(audioLevel.level);
      }
    }
  }
}

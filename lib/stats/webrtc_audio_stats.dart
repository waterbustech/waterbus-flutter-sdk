// Dart imports:
import 'dart:async';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';
import 'package:waterbus_sdk/types/models/audio_stats_params.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

@singleton
class WebRTCAudioStats {
  final List<AudioStatsParams> _receivers = [];
  AudioStatsParams? _sender;
  Timer? _timer;

  set setSender(AudioStatsParams? param) {
    _sender = param;
  }

  void addReceiver(AudioStatsParams param) {
    _receivers.add(param);
  }

  void removeReceiver(String peerConnectionId) {
    final int index = _receivers.indexWhere(
      (params) => params.peerConnection.peerConnectionId == peerConnectionId,
    );

    if (index < 0) return;

    _receivers.removeAt(index);
  }

  void initialize() {
    _timer ??= Timer.periodic(500.milliseconds, (timer) {
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
      final List<StatsReport> senderStats =
          await params.peerConnection.getStats();
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

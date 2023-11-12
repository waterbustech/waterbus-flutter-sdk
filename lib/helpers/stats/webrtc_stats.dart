// Dart imports:
import 'dart:async';

// Package imports:
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/duration_extensions.dart';
import 'package:waterbus_sdk/helpers/logger/logger.dart';

@singleton
class WebRTCStatsUtility {
  final Map<String, List<RTCRtpSender>> _senders = {};
  final Map<String, List<RTCRtpReceiver>> _receivers = {};
  final Map<String, VideoReceiverStats> _prevStats = {};
  final Map<String, num> _currentBitrate = {};

  Timer? _statsTimer;

  get currentBitrate => _currentBitrate;

  void initialize() {
    // Clear any previous measurements
    _prevStats.clear();
    _currentBitrate.clear();

    // Start collecting stats periodically
    _statsTimer = Timer.periodic(2.seconds, (timer) {
      _monitorSenderStats();
      _monitorReceiverStats();
    });
  }

  void addSenders(String id, List<RTCRtpSender> senders) {
    _senders[id] = senders;
  }

  void addReceivers(String id, List<RTCRtpReceiver> receivers) {
    _receivers[id] = receivers;
  }

  void removeSenders(String id) {
    _senders.remove(id);
  }

  void removeReceivers(String id) {
    _senders.remove(id);
  }

  void dispose() {
    _statsTimer?.cancel();
    _senders.clear();
    _receivers.clear();
    _currentBitrate.clear();
    _prevStats.clear();
  }

  Future<void> _monitorSenderStats() async {
    for (final senders in _senders.entries) {
      for (final sender in senders.value) {
        final List<StatsReport> statsReport = await sender.getStats();
        final stats = await _getStats(statsReport);

        if (stats != null) {
          if (_prevStats[senders.key] != null) {
            final num currentBitrate = computeBitrateForReceiverStats(
              stats,
              _prevStats[senders.key],
            );

            _currentBitrate[senders.key] = currentBitrate;
          }

          _prevStats[senders.key] = stats;

          WaterbusLogger().log(stats.toString());
        }
      }
    }
  }

  Future<void> _monitorReceiverStats() async {
    for (final receivers in _receivers.entries) {
      for (final receiver in receivers.value) {
        final List<StatsReport> statsReport = await receiver.getStats();
        final stats = await _getStats(statsReport, isSender: false);

        if (stats != null) {
          if (_prevStats[receivers.key] != null) {
            final num currentBitrate = computeBitrateForReceiverStats(
              stats,
              _prevStats[receivers.key],
            );

            _currentBitrate[receivers.key] = currentBitrate;
          }

          _prevStats[receivers.key] = stats;
        }
      }
    }
  }

  Future<VideoReceiverStats?> _getStats(
    List<StatsReport> stats, {
    bool isSender = true,
  }) async {
    VideoReceiverStats? receiverStats;
    for (final v in stats) {
      if (v.type == (isSender ? 'outbound-rtp' : 'inbound-rtp')) {
        receiverStats ??= VideoReceiverStats(v.id, v.timestamp);
        receiverStats.jitter = getNumValFromReport(v.values, 'jitter');
        receiverStats.jitterBufferDelay =
            _getNumValFromReport(v.values, 'jitterBufferDelay');
        receiverStats.bytesReceived =
            _getNumValFromReport(v.values, 'bytesReceived');
        receiverStats.packetsLost =
            _getNumValFromReport(v.values, 'packetsLost');
        receiverStats.framesDecoded =
            _getNumValFromReport(v.values, 'framesDecoded');
        receiverStats.framesDropped =
            _getNumValFromReport(v.values, 'framesDropped');
        receiverStats.framesReceived =
            _getNumValFromReport(v.values, 'framesReceived');
        receiverStats.packetsReceived =
            _getNumValFromReport(v.values, 'packetsReceived');
        receiverStats.framesPerSecond =
            _getNumValFromReport(v.values, 'framesPerSecond');
        receiverStats.frameWidth = _getNumValFromReport(v.values, 'frameWidth');
        receiverStats.frameHeight =
            _getNumValFromReport(v.values, 'frameHeight');
        receiverStats.pliCount = _getNumValFromReport(v.values, 'pliCount');
        receiverStats.firCount = _getNumValFromReport(v.values, 'firCount');
        receiverStats.nackCount = _getNumValFromReport(v.values, 'nackCount');
        receiverStats.roundTripTime = _getNumValFromReport(
          v.values,
          'roundTripTime',
        );
        receiverStats.decoderImplementation = _getStringValFromReport(
          v.values,
          'decoderImplementation',
        );

        final c = stats.firstWhereOrNull((element) => element.type == 'codec');
        if (c != null) {
          receiverStats.mimeType =
              _getStringValFromReport(c.values, 'mimeType');
          receiverStats.payloadType =
              _getNumValFromReport(c.values, 'payloadType');
          receiverStats.channels = _getNumValFromReport(c.values, 'channels');
          receiverStats.clockRate = _getNumValFromReport(c.values, 'clockRate');
        }
        break;
      }
    }

    return receiverStats;
  }

  // Future<void> _writeStatsToAsset() async {
  //   if (WaterbusSdk.recordBenchmarkPath.isEmpty || Platform.isAndroid) return;

  //   String stats = '''''';
  //   for (int index = 0; index < _bytesSentMeasurements.length; index++) {
  //     final double latency = _avgLatencyMeasurements[index] * 1000;
  //     stats += '''$index $latency ${_bytesSentMeasurements[index]}\n''';
  //   }

  //   final filePath = File(WaterbusSdk.recordBenchmarkPath);

  //   // Write the asset content to the local file
  //   try {
  //     await filePath.create();
  //     await filePath.writeAsString(stats);
  //     WaterbusLogger.instance.log("Saved stats in ${filePath.path}");
  //   } catch (e) {
  //     WaterbusLogger.instance.log("Error writing data to the file: $e");
  //   }
  // }

  num? _getNumValFromReport(Map<dynamic, dynamic> values, String key) {
    if (values.containsKey(key)) {
      return (values[key] is String)
          ? num.tryParse(values[key])
          : values[key] as num;
    }
    return null;
  }

  String? _getStringValFromReport(Map<dynamic, dynamic> values, String key) {
    if (values.containsKey(key)) {
      return values[key] as String;
    }
    return null;
  }
}

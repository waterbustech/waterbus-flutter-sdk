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
  final Map<String, List<RTCRtpReceiver>> _receivers = {};
  final Map<String, VideoReceiverStats> _prevStats = {};
  final Map<String, num> _currentBitrate = {};

  // MARK: sender
  final Map<String, List<RTCRtpSender>> _senders = {};
  num? _currentSenderBitrate;
  AudioSenderStats? _prevSenderStats;

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
        final stats = await _getSenderStats(statsReport);

        if (stats != null) {
          if (_prevStats[senders.key] != null) {
            _currentSenderBitrate = computeBitrateForSenderStats(
              stats,
              _prevSenderStats,
            );
          }

          _prevSenderStats = stats;

          WaterbusLogger()
              .log('${stats.toString()} | bitRate: $_currentSenderBitrate');
        }
      }
    }
  }

  Future<void> _monitorReceiverStats() async {
    for (final receivers in _receivers.entries) {
      for (final receiver in receivers.value) {
        final List<StatsReport> statsReport = await receiver.getStats();
        final stats = await _getReceiverStats(statsReport);

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

  Future<AudioSenderStats?> _getSenderStats(List<StatsReport> stats) async {
    AudioSenderStats? senderStats;
    for (final v in stats) {
      if (v.type == 'outbound-rtp') {
        senderStats ??= AudioSenderStats(v.id, v.timestamp);
        senderStats.packetsSent = getNumValFromReport(v.values, 'packetsSent');
        senderStats.packetsLost = getNumValFromReport(v.values, 'packetsLost');
        senderStats.bytesSent = getNumValFromReport(v.values, 'bytesSent');
        senderStats.roundTripTime =
            getNumValFromReport(v.values, 'roundTripTime');
        senderStats.jitter = getNumValFromReport(v.values, 'jitter');

        final c = stats.firstWhereOrNull((element) => element.type == 'codec');
        if (c != null) {
          senderStats.mimeType = getStringValFromReport(c.values, 'mimeType');
          senderStats.payloadType =
              getNumValFromReport(c.values, 'payloadType');
          senderStats.channels = getNumValFromReport(c.values, 'channels');
          senderStats.clockRate = getNumValFromReport(c.values, 'clockRate');
        }
        break;
      }
    }
    return senderStats;
  }

  Future<VideoReceiverStats?> _getReceiverStats(List<StatsReport> stats) async {
    VideoReceiverStats? receiverStats;
    for (final v in stats) {
      if (v.type == 'inbound-rtp') {
        receiverStats ??= VideoReceiverStats(v.id, v.timestamp);
        receiverStats.jitter = getNumValFromReport(v.values, 'jitter');
        receiverStats.jitterBufferDelay =
            getNumValFromReport(v.values, 'jitterBufferDelay');
        receiverStats.bytesReceived =
            getNumValFromReport(v.values, 'bytesReceived');
        receiverStats.packetsLost =
            getNumValFromReport(v.values, 'packetsLost');
        receiverStats.framesDecoded =
            getNumValFromReport(v.values, 'framesDecoded');
        receiverStats.framesDropped =
            getNumValFromReport(v.values, 'framesDropped');
        receiverStats.framesReceived =
            getNumValFromReport(v.values, 'framesReceived');
        receiverStats.packetsReceived =
            getNumValFromReport(v.values, 'packetsReceived');
        receiverStats.framesPerSecond =
            getNumValFromReport(v.values, 'framesPerSecond');
        receiverStats.frameWidth = getNumValFromReport(v.values, 'frameWidth');
        receiverStats.frameHeight =
            getNumValFromReport(v.values, 'frameHeight');
        receiverStats.pliCount = getNumValFromReport(v.values, 'pliCount');
        receiverStats.firCount = getNumValFromReport(v.values, 'firCount');
        receiverStats.nackCount = getNumValFromReport(v.values, 'nackCount');

        receiverStats.decoderImplementation = getStringValFromReport(
          v.values,
          'decoderImplementation',
        );

        final c = stats.firstWhereOrNull((element) => element.type == 'codec');
        if (c != null) {
          receiverStats.mimeType =
              getStringValFromReport(c.values, 'mimeType');
          receiverStats.payloadType =
              getNumValFromReport(c.values, 'payloadType');
          receiverStats.channels = getNumValFromReport(c.values, 'channels');
          receiverStats.clockRate = getNumValFromReport(c.values, 'clockRate');
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
}

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
  final Map<String, num> _bitrateFoLayers = {};
  num? _currentSenderBitrate;
  Map<String, VideoSenderStats>? _prevSenderStats;

  Timer? _statsTimer;

  get currentSenderBitrate => _currentSenderBitrate;
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
    _receivers.remove(id);
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

        final Map<String, VideoSenderStats> statsMap = {};

        for (final s in stats) {
          statsMap[s.rid ?? 'f'] = s;
        }

        if (_prevSenderStats != null) {
          num totalBitrate = 0;
          statsMap.forEach((key, s) {
            final prev = _prevSenderStats![key];
            final bitRateForlayer = computeBitrateForSenderStats(s, prev);
            _bitrateFoLayers[key] = bitRateForlayer;
            totalBitrate += bitRateForlayer;
          });
          _currentSenderBitrate = totalBitrate;
        }

        _prevSenderStats = statsMap;
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

  Future<List<VideoSenderStats>> _getSenderStats(
    List<StatsReport> stats,
  ) async {
    final List<VideoSenderStats> items = [];
    for (final v in stats) {
      if (v.type == 'outbound-rtp') {
        final VideoSenderStats vs = VideoSenderStats(v.id, v.timestamp);
        vs.frameHeight = getNumValFromReport(v.values, 'frameHeight');
        vs.frameWidth = getNumValFromReport(v.values, 'frameWidth');
        vs.framesPerSecond = getNumValFromReport(v.values, 'framesPerSecond');
        vs.firCount = getNumValFromReport(v.values, 'firCount');
        vs.pliCount = getNumValFromReport(v.values, 'pliCount');
        vs.nackCount = getNumValFromReport(v.values, 'nackCount');
        vs.packetsSent = getNumValFromReport(v.values, 'packetsSent');
        vs.bytesSent = getNumValFromReport(v.values, 'bytesSent');
        vs.framesSent = getNumValFromReport(v.values, 'framesSent');
        vs.rid = getStringValFromReport(v.values, 'rid');
        vs.encoderImplementation =
            getStringValFromReport(v.values, 'encoderImplementation');
        vs.retransmittedPacketsSent =
            getNumValFromReport(v.values, 'retransmittedPacketsSent');
        vs.qualityLimitationReason =
            getStringValFromReport(v.values, 'qualityLimitationReason');
        vs.qualityLimitationResolutionChanges =
            getNumValFromReport(v.values, 'qualityLimitationResolutionChanges');

        if (vs.framesSent != null) {
          // Monitor frames info
          WaterbusLogger().log(vs.infoVideo());
        }

        // locate the appropriate remote-inbound-rtp item
        final remoteId = getStringValFromReport(v.values, 'remoteId');
        final r = stats.firstWhereOrNull((element) => element.id == remoteId);
        if (r != null) {
          vs.jitter = getNumValFromReport(r.values, 'jitter');
          vs.packetsLost = getNumValFromReport(r.values, 'packetsLost');
          vs.roundTripTime = getNumValFromReport(r.values, 'roundTripTime');

          // Monitor latency & jitter
          WaterbusLogger().log(vs.toString());
        }
        final c = stats.firstWhereOrNull((element) => element.type == 'codec');
        if (c != null) {
          vs.mimeType = getStringValFromReport(c.values, 'mimeType');
          vs.payloadType = getNumValFromReport(c.values, 'payloadType');
          vs.channels = getNumValFromReport(c.values, 'channels');
          vs.clockRate = getNumValFromReport(c.values, 'clockRate');
        }
        items.add(vs);
      }
    }
    return items;
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
          receiverStats.mimeType = getStringValFromReport(c.values, 'mimeType');
          receiverStats.payloadType =
              getNumValFromReport(c.values, 'payloadType');
          receiverStats.channels = getNumValFromReport(c.values, 'channels');
          receiverStats.clockRate = getNumValFromReport(c.values, 'clockRate');
        }
        break;
      }
    }

    if (receiverStats?.framesReceived != null) {
      // Monitor frames receive
      WaterbusLogger().log(receiverStats!.infoVideo());
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

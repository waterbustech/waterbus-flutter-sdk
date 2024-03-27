// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/duration_extensions.dart';
import 'package:waterbus_sdk/helpers/logger/logger.dart';

@singleton
class WebRTCVideoStats {
  // MARK: State of receiver
  final Map<String, List<RTCRtpReceiver>> _receivers = {};
  final Map<String, VideoReceiverStats> _prevStats = {};
  final Map<String, num> _currentReceiverBitrate = {};

  // MARK: State of sender
  final List<RTCRtpSender> _senders = [];
  final Map<String, num> _bitrateFoLayers = {};
  num? _currentSenderBitrate;
  Map<String, VideoSenderStats> _prevSenderStats = {};
  final List<WaterbusStatsBenchmark> _statsBenchmark = [];

  Timer? _statsTimer;

  get currentSenderBitrate => _currentSenderBitrate;
  get currentBitrate => _currentReceiverBitrate;

  void initialize() {
    // Clear any previous measurements
    _prevStats.clear();
    _currentReceiverBitrate.clear();

    // Start collecting stats periodically
    _statsTimer = Timer.periodic(2.seconds, (timer) {
      _monitorSenderStats();
      _monitorReceiverStats();

      _recordStats();
    });
  }

  void addSenders(String id, List<RTCRtpSender> senders) {
    _senders.addAll(senders);
  }

  void addReceivers(String id, List<RTCRtpReceiver> receivers) {
    _receivers[id] = receivers;
  }

  void removeSenders() {
    _senders.clear();
  }

  void removeReceivers(String id) {
    _receivers.remove(id);
  }

  void dispose() {
    if (kIsWeb) return;

    if (_statsTimer == null) return;

    _statsTimer?.cancel();
    _statsTimer = null;

    _writeStatsToFile();
    _senders.clear();
    _receivers.clear();
    _currentReceiverBitrate.clear();
    _prevStats.clear();
  }

  Future<void> _monitorSenderStats() async {
    for (final sender in _senders) {
      try {
        final List<StatsReport> statsReport = await sender.getStats();
        final List<VideoSenderStats> stats = await _getSenderStats(statsReport);

        final Map<String, VideoSenderStats> statsMap = {};

        for (final s in stats) {
          if (s.rid == null) continue;

          statsMap[s.rid ?? 'f'] = s;
        }

        if (_prevSenderStats.isNotEmpty) {
          num totalBitrate = 0;

          for (final stats in statsMap.entries) {
            final prev = _prevSenderStats[stats.key];
            final bitRateForlayer = computeBitrateForSenderStats(
              stats.value,
              prev,
            );
            _bitrateFoLayers[stats.key] = bitRateForlayer;
            totalBitrate += bitRateForlayer;
          }

          _currentSenderBitrate = totalBitrate;
        }

        for (final stats in statsMap.entries) {
          _prevSenderStats[stats.key] = stats.value;
        }
      } catch (error) {
        WaterbusLogger().bug(error.toString());
      }
    }
  }

  Future<void> _monitorReceiverStats() async {
    for (final receivers in _receivers.entries) {
      for (final receiver in receivers.value) {
        try {
          final List<StatsReport> statsReport = await receiver.getStats();
          final stats = await _getReceiverStats(statsReport);

          if (stats != null) {
            if (_prevStats[receivers.key] != null) {
              final num currentBitrate = computeBitrateForReceiverStats(
                stats,
                _prevStats[receivers.key],
              );

              _currentReceiverBitrate[receivers.key] = currentBitrate;
            }

            _prevStats[receivers.key] = stats;
          }
        } catch (error) {
          WaterbusLogger().bug(error.toString());
        }
      }
    }
  }

  Future<List<VideoSenderStats>> _getSenderStats(
    List<StatsReport> stats,
  ) async {
    final List<VideoSenderStats> items = [];
    for (final v in stats) {
      if (v.type == 'outbound-rtp' && v.values['kind'] == 'video') {
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
        vs.totalEncodeTime = getNumValFromReport(v.values, 'totalEncodeTime');
        vs.rid = vs.frameHeight != null
            ? getNumValFromReport(v.values, 'ssrc').toString()
            : null;
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
      if (v.type == 'inbound-rtp' && v.values['kind'] == 'video') {
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

  void _recordStats() {
    final VideoSenderStats? stats = _prevSenderStats.values.firstOrNull;

    _statsBenchmark.add(
      WaterbusStatsBenchmark(
        latency: stats?.roundTripTime ?? 0,
        bitrate: _currentSenderBitrate ?? 0,
        bytesSent: stats?.bytesSent ?? 0,
        jitter: stats?.jitter ?? 0,
        packetsLost: stats?.packetsLostPercent ?? 0,
        totalEncodeTime: stats?.totalEncodeTime ?? 0,
      ),
    );
  }

  Future<void> _writeStatsToFile() async {
    if (WaterbusSdk.recordBenchmarkPath.isNotEmpty) {
      String stats = '''''';
      for (int index = 1; index <= _statsBenchmark.length; index++) {
        stats += '''${index * 2} ${_statsBenchmark[index - 1].toString()}\n''';
      }

      final filePath = File(WaterbusSdk.recordBenchmarkPath);

      // Write the asset content to the local file
      try {
        await filePath.create();
        await filePath.writeAsString(stats);
        WaterbusLogger.instance.log("Saved stats in ${filePath.path}");
      } catch (e) {
        WaterbusLogger.instance.log("Error writing data to the file: $e");
      }
    }

    _statsBenchmark.clear();
    _currentSenderBitrate = null;
    _prevSenderStats = {};
  }
}

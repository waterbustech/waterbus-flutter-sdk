// Dart imports:
import 'dart:async';
import 'dart:io';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/duration_extensions.dart';
import 'package:waterbus_sdk/helpers/logger/logger.dart';

class WebRTCStatsUtility {
  RTCPeerConnection peerConnection;

  WebRTCStatsUtility(this.peerConnection);

  final List<double> _latencyMeasurements = [];
  final List<double> _avgLatencyMeasurements = [];
  final List<double> _bytesSentMeasurements = [];
  Timer? _statsTimer;

  void start() {
    // Clear any previous measurements
    _latencyMeasurements.clear();
    _avgLatencyMeasurements.clear();
    _bytesSentMeasurements.clear();

    // Start collecting stats periodically
    _statsTimer = Timer.periodic(1.seconds, (timer) {
      _collectStats();
    });
  }

  void stop() {
    _statsTimer?.cancel();
    _writeStatsToAsset();
  }

  Future<void> _collectStats() async {
    try {
      // Get the statistics
      final List<StatsReport> report = await peerConnection.getStats();

      // Calculate latency from the "remote-inbound-rtp" statistics
      for (final r in report) {
        if (r.values['kind'] == 'video' && r.values['roundTripTime'] != null) {
          final double roundTripTime = r.values['roundTripTime'] ?? 0;
          _latencyMeasurements.add(roundTripTime);
        }

        if (r.type == 'outbound-rtp' && r.values['kind'] == 'video') {
          // Access packet size information
          final int bytesSent = r.values['bytesSent'] ?? 0;

          // Convert bytes to KB
          final double kilobytesSent = bytesSent / 1024.0;

          _bytesSentMeasurements.add(kilobytesSent);
          _avgLatencyMeasurements.add(_calculateAverageLatency() * 1000);

          // Print packet size in KB
          WaterbusLogger.instance.log('Kilobytes Sent: $kilobytesSent KB');
        }
      }

      // Calculate and log the average latency
      final double averageLatency = _calculateAverageLatency() * 1000;
      WaterbusLogger.instance.log('Average Latency: $averageLatency ms');
    } catch (e) {
      WaterbusLogger.instance.log('Error collecting WebRTC stats: $e');
    }
  }

  double _calculateAverageLatency() {
    if (_latencyMeasurements.isEmpty) {
      return 0.0; // No measurements yet
    }
    final double totalLatency = _latencyMeasurements.reduce((a, b) => a + b);
    return totalLatency / _latencyMeasurements.length;
  }

  Future<void> _writeStatsToAsset() async {
    if (WaterbusSdk.recordBenchmarkPath.isEmpty || Platform.isAndroid) return;

    String stats = '''''';
    for (int index = 0; index < _bytesSentMeasurements.length; index++) {
      final double latency = _avgLatencyMeasurements[index] * 1000;
      stats += '''$index $latency ${_bytesSentMeasurements[index]}\n''';
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
}

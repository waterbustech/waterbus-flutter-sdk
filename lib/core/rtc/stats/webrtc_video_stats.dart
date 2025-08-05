import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/constants.dart';
import 'package:waterbus_sdk/types/externals/models/rtc_participant_stats.dart';
import 'package:waterbus_sdk/types/internals/models/stats.dart';
import 'package:waterbus_sdk/types/internals/models/video_stats_params.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@singleton
class WebRTCVideoStats {
  // MARK: State of sender
  final Map<String, VideoStatsParam> _senders = {};
  final Map<String, num> _bitrateFoLayers = {};
  num? _currentSenderBitrate;
  final Map<String, VideoSenderStats> _prevSenderStats = {};

  // MARK: State of receiver
  final Map<String, VideoStatsParam> _receivers = {};
  final Map<String, VideoReceiverStats> _prevStats = {};
  final Map<String, num> _currentReceiverBitrate = {};

  Timer? _statsTimer;

  get currentSenderBitrate => _currentSenderBitrate;

  void initialize() {
    // Start collecting stats periodically
    _statsTimer = Timer.periodic(2.seconds, (timer) {
      _monitorSenderStats();
      _monitorReceiverStats();
    });
  }

  void addSenders({
    required String ownerId,
    required List<RTCRtpSender> senders,
    required Function(RtcParticipantStats) callback,
  }) {
    final videoSenders =
        senders.where((s) => s.track?.kind == 'video').toList();

    _senders[ownerId] = VideoStatsParam(
      ownerId: kIsMine,
      callBack: callback,
      senders: videoSenders,
    );
  }

  void removeSenders(String ownerId) {
    _senders.removeWhere((k, v) => k == ownerId);
  }

  void addReceivers({
    required String ownerId,
    required List<RTCRtpReceiver> receivers,
    required Function(RtcParticipantStats) callback,
  }) {
    _receivers[ownerId] = VideoStatsParam(
      ownerId: ownerId,
      callBack: callback,
      receivers: receivers,
    );
  }

  void removeReceivers(String ownerId) {
    _receivers.removeWhere((k, v) => k.startsWith(ownerId));
  }

  void dispose() {
    if (_statsTimer == null) return;

    _statsTimer?.cancel();
    _statsTimer = null;

    _senders.clear();
    _receivers.clear();
  }

  Future<void> _monitorSenderStats() async {
    final sendersEntries = _senders.entries.toList();

    for (final senders in sendersEntries) {
      if (!_senders.containsKey(senders.key)) continue;

      for (final sender in senders.value.senders) {
        try {
          final List<StatsReport> statsReport = await sender.getStats();
          final List<VideoSenderStats> stats =
              await _getSenderStats(statsReport);

          if (stats.isEmpty) continue;

          final Map<String, VideoSenderStats> statsMap = {};
          for (final s in stats) {
            if (s.rid == null || s.bytesSent == 0) continue;
            statsMap[s.rid ?? 'f'] = s;
          }

          if (_prevSenderStats.isNotEmpty && statsMap.isNotEmpty) {
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

            final RtcParticipantStats senderStats = RtcParticipantStats(
              frameWidth: stats.last.frameWidth,
              frameHeight: stats.last.frameHeight,
              jitter: stats.last.jitter,
              roundTripTime: stats.last.roundTripTime,
              packetsLost: stats.last.packetsLost,
              bitrate: _currentSenderBitrate,
              fps: stats.last.framesPerSecond,
              framesSent: stats.last.framesSent,
            );

            _senders[senders.key]?.callBack.call(senderStats);
          }

          for (final stats in statsMap.entries) {
            _prevSenderStats[stats.key] = stats.value;
          }
        } catch (error) {
          WaterbusLogger.instance.bug(error.toString());
        }
      }
    }
  }

  Future<void> _monitorReceiverStats() async {
    // Create a copy of the entries to avoid concurrent modification
    final receiversEntries = _receivers.entries.toList();

    for (final receivers in receiversEntries) {
      // Check if the receiver still exists in the map (in case it was removed)
      if (!_receivers.containsKey(receivers.key)) continue;

      for (final receiver in receivers.value.receivers) {
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

              final RtcParticipantStats receiverStats = RtcParticipantStats(
                frameWidth: stats.frameWidth,
                frameHeight: stats.frameHeight,
                jitter: stats.jitter,
                packetsLost: stats.packetsLost,
                bitrate: currentBitrate,
                fps: stats.framesPerSecond,
                framesReceived: stats.framesReceived,
              );

              // Check again if the receiver still exists before calling callback
              _receivers[receivers.key]?.callBack.call(receiverStats);
            }
            _prevStats[receivers.key] = stats;
          }
        } catch (error) {
          WaterbusLogger.instance.bug(error.toString());
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

        // locate the appropriate remote-inbound-rtp item
        final remoteId = getStringValFromReport(v.values, 'remoteId');
        final r = stats.firstWhereOrNull((element) => element.id == remoteId);
        if (r != null) {
          vs.jitter = getNumValFromReport(r.values, 'jitter');
          vs.packetsLost = getNumValFromReport(r.values, 'packetsLost');
          vs.roundTripTime = getNumValFromReport(
            r.values,
            'roundTripTime',
          );
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

    if (receiverStats?.framesReceived != null) {}

    return receiverStats;
  }
}

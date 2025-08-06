// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2023 LiveKit, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';

abstract class CodecStats {
  String? mimeType;
  num? payloadType;
  num? channels;
  num? clockRate;

  String infoVideo() {
    return '';
  }
}

// key stats for senders and receivers
class SenderStats extends CodecStats {
  SenderStats(this.streamId, this.timestamp);

  /// number of packets sent
  num? packetsSent;

  /// number of bytes sent
  num? bytesSent;

  /// jitter as perceived by remote
  num? jitter;

  /// packets reported lost by remote
  num? packetsLost;

  /// RTT reported by remote
  num? roundTripTime;

  /// ID of the outbound stream
  String streamId;

  String? encoderImplementation;

  num timestamp;
}

class AudioSenderStats extends SenderStats {
  AudioSenderStats(super.streamId, super.timestamp);
}

class VideoSenderStats extends SenderStats {
  VideoSenderStats(super.streamId, super.timestamp);

  num? firCount;

  num? pliCount;

  num? nackCount;

  String? rid;

  num? frameWidth;

  num? frameHeight;

  num? framesSent;

  num? framesPerSecond;

  num? totalEncodeTime;

  // bandwidth, cpu, other, none
  String? qualityLimitationReason;

  num? qualityLimitationResolutionChanges;

  num? retransmittedPacketsSent;

  @override
  String toString() {
    return 'latency: ${((roundTripTime ?? 0) * 1000).toStringAsFixed(2)}ms | jitter: ${jitter?.toStringAsFixed(6)} | packetsLost: $packetsLost';
  }

  @override
  String infoVideo() {
    return 'framesSent: $framesSent | frameHeight: $frameHeight | frameWidth: $frameWidth | framePerSecond: $framesPerSecond';
  }

  double get packetsLostPercent {
    if (packetsLost == null || packetsSent == null || packetsLost == 0) {
      return 0;
    }

    return packetsSent! / packetsLost!;
  }
}

class ReceiverStats extends CodecStats {
  ReceiverStats(this.streamId, this.timestamp);
  num? jitterBufferDelay;

  /// packets reported lost by remote
  num? packetsLost;

  /// number of packets sent
  num? packetsReceived;

  num? bytesReceived;

  String streamId;

  num? jitter;

  num timestamp;
}

class AudioReceiverStats extends ReceiverStats {
  AudioReceiverStats(super.streamId, super.timestamp);

  num? concealedSamples;

  num? concealmentEvents;

  num? silentConcealedSamples;

  num? silentConcealmentEvents;

  num? totalAudioEnergy;

  num? totalSamplesDuration;
}

class VideoReceiverStats extends ReceiverStats {
  VideoReceiverStats(super.streamId, super.timestamp);

  num? framesDecoded;

  num? framesDropped;

  num? framesReceived;

  num? framesPerSecond;

  num? frameWidth;

  num? frameHeight;

  num? firCount;

  num? pliCount;

  num? nackCount;

  String? decoderImplementation;

  @override
  String infoVideo() {
    return 'framesReceived: $framesReceived | packageReceived: $packetsReceived | packetsLost: $packetsLost';
  }
}

class WaterbusStatsBenchmark {
  final num latency;
  final num bitrate;
  final num bytesSent;
  final num jitter;
  final num packetsLost;
  final num totalEncodeTime;
  WaterbusStatsBenchmark({
    required this.latency,
    required this.bitrate,
    required this.bytesSent,
    required this.jitter,
    required this.packetsLost,
    required this.totalEncodeTime,
  });

  @override
  String toString() {
    return '${(latency * 1000).toStringAsFixed(2)} $bitrate ${jitter.toStringAsFixed(6)} ${(bytesSent / (1024 * 1024)).toStringAsFixed(4)} $packetsLost ${(totalEncodeTime * 1000).toStringAsFixed(0)}';
  }
}

num computeBitrateForSenderStats(
  SenderStats currentStats,
  SenderStats? prevStats,
) {
  if (prevStats == null) {
    return 0;
  }
  num? bytesNow;
  num? bytesPrev;
  bytesNow = currentStats.bytesSent;
  bytesPrev = prevStats.bytesSent;
  if (bytesNow == null || bytesPrev == null) {
    return 0;
  }
  if (kIsWeb) {
    return ((bytesNow - bytesPrev) * 8) /
        (currentStats.timestamp - prevStats.timestamp);
  }

  return ((bytesNow - bytesPrev) * 8 * 1000) /
      (currentStats.timestamp - prevStats.timestamp);
}

num computeBitrateForReceiverStats(
  ReceiverStats currentStats,
  ReceiverStats? prevStats,
) {
  if (prevStats == null) {
    return 0;
  }
  num? bytesNow;
  num? bytesPrev;

  bytesNow = currentStats.bytesReceived;
  bytesPrev = prevStats.bytesReceived;

  if (bytesNow == null || bytesPrev == null) {
    return 0;
  }
  if (kIsWeb) {
    return ((bytesNow - bytesPrev) * 8) /
        (currentStats.timestamp - prevStats.timestamp);
  }

  return ((bytesNow - bytesPrev) * 8 * 1000) /
      (currentStats.timestamp - prevStats.timestamp);
}

num? getNumValFromReport(Map<dynamic, dynamic> values, String key) {
  if (values.containsKey(key)) {
    return (values[key] is String)
        ? num.tryParse(values[key])
        : values[key] as num;
  }
  return null;
}

String? getStringValFromReport(Map<dynamic, dynamic> values, String key) {
  if (values.containsKey(key)) {
    return values[key] as String;
  }
  return null;
}

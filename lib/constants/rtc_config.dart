import 'package:flutter/foundation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class RtcConfig {
  static Map<String, dynamic> configuration(
    bool e2eeEnabled, {
    IceServersResponse iceServers = kIceServers,
  }) {
    return {
      'iceServers': iceServers.toMap(),
      'sdpSemantics': 'unified-plan',
      'iceCandidatePoolSize': 20,
      "audioJitterBufferMaxPackets": 50,
      'bundlePolicy': 'max-bundle',
      "rtcpMuxPolicy": "require",
      'iceTransportPolicy': 'all',
      'encodedInsertableStreams': kIsWeb && e2eeEnabled,
    };
  }

  static const Map<String, dynamic> offerPublisherSdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  static const Map<String, dynamic> offerSubscriberSdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  static final simulcastEncodings = [
    RTCRtpEncoding(
      rid: 'f',
      maxFramerate: 30,
      maxBitrate: 2000000,
    ),
    RTCRtpEncoding(
      rid: 'h',
      maxFramerate: 24,
      scaleResolutionDownBy: 2.0,
      maxBitrate: 1000000,
    ),
    RTCRtpEncoding(
      rid: 'q',
      maxFramerate: 15,
      scaleResolutionDownBy: 4.0,
      maxBitrate: 500000,
    ),
  ];

  static final svcEncodings = [
    RTCRtpEncoding(
      maxBitrate: 3000000,
      numTemporalLayers: 3,
      scalabilityMode: 'L1T2',
    ),
  ];
}

import 'package:flutter/foundation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class WebRTCConfigurations {
  static const Map<String, dynamic> configurationWebRTC = {
    'iceServers': [
      {
        "urls": "stun:stun.cloudflare.com:3478",
      },
    ],
    'sdpSemantics': 'unified-plan',
    'iceCandidatePoolSize': 20,
    "audioJitterBufferMaxPackets": 50,
    'bundlePolicy': 'max-bundle',
    "rtcpMuxPolicy": "require",
    'iceTransportPolicy': 'all',
    'encodedInsertableStreams': kIsWeb,
  };

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

  static final videoEncodings = [
    RTCRtpEncoding(
      rid: 'f',
      maxBitrate: 2500000,
      minBitrate: 1500000,
      maxFramerate: 30,
      // scalabilityMode: 'L1T3',
    ),
    RTCRtpEncoding(
      rid: 'h',
      maxBitrate: 900000,
      minBitrate: 500000,
      maxFramerate: 24,
      // scalabilityMode: 'L1T2',
      scaleResolutionDownBy: 2.0,
    ),
    RTCRtpEncoding(
      rid: 'q',
      maxBitrate: 300000,
      minBitrate: 100000,
      maxFramerate: 15,
      // scalabilityMode: 'L1T1',
      scaleResolutionDownBy: 4.0,
    ),
  ];
}

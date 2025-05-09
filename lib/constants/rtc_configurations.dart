import 'package:flutter/foundation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

class RTCConfigurations {
  static Map<String, dynamic> configuration(bool e2eeEnabled) {
    return {
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
    ),
    RTCRtpEncoding(
      rid: 'h',
      maxFramerate: 24,
      scaleResolutionDownBy: 2.0,
    ),
    RTCRtpEncoding(
      rid: 'q',
      maxFramerate: 15,
      scaleResolutionDownBy: 4.0,
    ),
  ];

  static final svcEncodings = [
    RTCRtpEncoding(
      scalabilityMode: 'L3T1_KEY',
    ),
  ];
}

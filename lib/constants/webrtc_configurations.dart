class WebRTCConfigurations {
  static const Map<String, dynamic> configurationWebRTC = {
    'iceServers': [
      {
        "urls": "stun:turn.waterbus.tech:3478",
        "username": "waterbus",
        "credential": "waterbus",
      },
      {
        "urls": "turn:turn.waterbus.tech:3478?transport=udp",
        "username": "waterbus",
        "credential": "waterbus",
      }
    ],
    'iceTransportPolicy': 'all',
    // 'bundlePolicy': 'max-bundle',
    'sdpSemantics': 'unified-plan',
    // 'encodedInsertableStreams': true,
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
}

class WebRTCConfigurations {
  static const Map<String, dynamic> configurationWebRTC = {
    'iceServers': [
      {
        "urls": "stun:turn.waterbus.tech:3478",
      },
      {
        "urls": "turn:turn.waterbus.tech:3478?transport=udp",
        "username": "waterbus",
        "credential": "waterbus",
      }
    ],
    'sdpSemantics': 'unified-plan',
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

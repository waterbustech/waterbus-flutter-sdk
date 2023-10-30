class WebRTCConfigurations {
  static const Map<String, dynamic> configurationWebRTC = {
    'iceServers': [
      {
        "urls": "stun:149.28.156.10:3478",
        "username": "waterbus",
        "credential": "lambiengcode",
      },
      {
        "urls": "turn:149.28.156.10:3478?transport=udp",
        "username": "waterbus",
        "credential": "lambiengcode",
      }
    ],
    'iceTransportPolicy': 'all',
    'bundlePolicy': 'max-bundle',
    'rtcpMuxPolicy': 'require',
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

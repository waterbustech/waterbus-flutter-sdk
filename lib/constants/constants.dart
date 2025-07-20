// Method Channel
const String kNativeChannel = 'waterbus-sdk/native-plugin';
const String kReplayKitChannel = 'waterbus-sdk/replaykit-channel';

// Others
const int kMinAV1AndroidSupported = 14;
const int kMinAV1iOSSupported = 14;
const String kIsMine = 'isMine';

const kIceServers = [
  {
    'urls': ['stun:turn.waterbus.tech:3478'],
  },
  {
    'urls': ['turn:turn.waterbus.tech:3478?transport=udp'],
    'username': 'waterbus',
    'credential': 'turnturn',
  }
];

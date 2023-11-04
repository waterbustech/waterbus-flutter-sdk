// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/logger/logger.dart';

@singleton
class WebRTCFrameCrypto {
  final WaterbusLogger _logger;
  WebRTCFrameCrypto(this._logger);

  // Constants Values
  static const List<String> audioCodecList = <String>[
    'OPUS',
    'ISAC',
    'PCMA',
    'PCMU',
    'G729',
  ];

  final FrameCryptorFactory _frameCyrptorFactory = frameCryptorFactory;
  final Map<String, FrameCryptor> _frameCyrptors = {};
  final Uint8List aesKey = Uint8List.fromList([
    200,
    244,
    58,
    72,
    214,
    245,
    86,
    82,
    192,
    127,
    23,
    153,
    167,
    172,
    122,
    234,
    140,
    70,
    175,
    74,
    61,
    11,
    134,
    58,
    185,
    102,
    172,
    17,
    11,
    6,
    119,
    253,
  ]);

  String? _senderParticipantId;
  KeyProvider? _keyProvider;
  final String audioCodec = audioCodecList.first;
  WebRTCCodec _videoCodec = WebRTCCodec.h264;

  Future<void> initialize(
    String key, {
    required WebRTCCodec codec,
  }) async {
    final KeyProviderOptions keyProviderOptions = KeyProviderOptions(
      sharedKey: true,
      ratchetSalt: Uint8List.fromList(key.codeUnits),
      ratchetWindowSize: 16,
    );

    _keyProvider ??= await _frameCyrptorFactory.createDefaultKeyProvider(
      keyProviderOptions,
    );

    _videoCodec = codec;

    await _keyProvider?.setSharedKey(key: aesKey);
  }

  Future<void> enableEncryption({
    required RTCPeerConnection peerConnection,
    required bool enabled,
  }) async {
    final List<RTCRtpSender> senders = await peerConnection.senders;

    for (final sender in senders) {
      final String trackId = sender.track?.id ?? '';
      final String id =
          '${sender.track?.kind.toString().trim()}_${trackId}_sender';

      if (!_frameCyrptors.containsKey(id)) {
        final frameCyrptor =
            await _frameCyrptorFactory.createFrameCryptorForRtpSender(
          participantId: id,
          sender: sender,
          algorithm: Algorithm.kAesGcm,
          keyProvider: _keyProvider!,
        );

        frameCyrptor.onFrameCryptorStateChanged = (participantId, state) {
          _logger.log('Encryption: $participantId $state');
        };

        _frameCyrptors[id] = frameCyrptor;
        await frameCyrptor.setKeyIndex(0);
      }

      if (sender.track?.kind.toString().trim() == 'video') {
        _senderParticipantId = id;
      }

      final frameCyrptor0 = _frameCyrptors[id];

      if (enabled) {
        await frameCyrptor0?.setEnabled(true);
        await _keyProvider?.setKey(participantId: id, index: 0, key: aesKey);
      } else {
        await frameCyrptor0?.setEnabled(false);
      }

      await frameCyrptor0?.updateCodec(
        sender.track?.kind.toString().trim() == 'video'
            ? _videoCodec.codec.toUpperCase()
            : audioCodec,
      );
    }
  }

  Future<void> enableDecryption({
    required RTCPeerConnection peerConnection,
    required WebRTCCodec codec,
    required bool enabled,
  }) async {
    final List<RTCRtpReceiver> receivers = await peerConnection.receivers;

    for (final receiver in receivers) {
      final String trackId = receiver.track?.id ?? '';
      final String id = '${receiver.track?.kind}_${trackId}_receiver';
      if (!_frameCyrptors.containsKey(id)) {
        final frameCyrptor =
            await _frameCyrptorFactory.createFrameCryptorForRtpReceiver(
          participantId: id,
          receiver: receiver,
          algorithm: Algorithm.kAesGcm,
          keyProvider: _keyProvider!,
        );

        frameCyrptor.onFrameCryptorStateChanged = (participantId, state) {
          _logger.log('Decryption: $participantId $state');
        };

        _frameCyrptors[id] = frameCyrptor;
        await frameCyrptor.setKeyIndex(0);
      }

      final frameCyrptor0 = _frameCyrptors[id];

      if (enabled) {
        await frameCyrptor0?.setEnabled(true);
        await _keyProvider?.setKey(participantId: id, index: 0, key: aesKey);
      } else {
        await frameCyrptor0?.setEnabled(false);
      }

      await frameCyrptor0?.updateCodec(
        receiver.track?.kind == 'video'
            ? codec.codec.toUpperCase()
            : audioCodec,
      );
    }
  }

  Future<void> ratchetKey() async {
    await _keyProvider?.ratchetKey(
      participantId: _senderParticipantId!,
      index: 0,
    );
  }

  void stopVideo() {
    _frameCyrptors.removeWhere((key, value) {
      if (key.startsWith('video')) {
        value.dispose();
        return true;
      }
      return false;
    });
  }

  void stopAudio() {
    _frameCyrptors.removeWhere((key, value) {
      if (key.startsWith('audio')) {
        value.dispose();
        return true;
      }
      return false;
    });
  }

  void dispose() {
    _senderParticipantId = null;
    _keyProvider = null;
  }
}

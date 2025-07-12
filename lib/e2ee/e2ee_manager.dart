import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/e2ee/key_provider.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@singleton
class E2EEManager {
  final WaterbusLogger _logger = WaterbusLogger.instance;
  final FrameCryptorFactory _fcFactory = frameCryptorFactory;
  final Map<Map<String, String>, FrameCryptor> _frameCryptors = {};

  final Algorithm _algorithm = Algorithm.kAesGcm;
  final RTCAudioCodec _audioCodec = RTCAudioCodec.opus;
  RTCVideoCodec _videoCodec = RTCVideoCodec.h264;
  BaseKeyProvider? _keyProvider;
  String? _identity;
  bool _enabled = true;

  Future<void> initialize(
    String key, {
    required RTCVideoCodec codec,
    required String participantId,
    bool enabled = true,
  }) async {
    _videoCodec = codec;
    _identity = participantId;
    _enabled = enabled;

    _keyProvider ??= await BaseKeyProvider.create(
      ratchetSalt: key,
      ratchetWindowSize: 16,
    );

    await ratchetKey(participantId: participantId);

    await _keyProvider?.setKey(WaterbusSdk.webrtcE2eeKey);
  }

  Future<void> addRtpSender({required RTCRtpSender sender}) async {
    try {
      if (_identity == null || _keyProvider == null) return;

      if (!_videoCodec.isSFrameSuported || !_enabled) return;

      final String trackId = sender.track?.id ?? '';
      final String id =
          '${sender.track?.kind.toString().trim()}_${trackId}_sender';

      final frameCryptor = await _fcFactory.createFrameCryptorForRtpSender(
        participantId: _identity!,
        sender: sender,
        algorithm: _algorithm,
        keyProvider: _keyProvider!.keyProvider,
      );

      frameCryptor.onFrameCryptorStateChanged = (participantId, state) {
        _logger.log('Encryption: $participantId $state');
      };

      _frameCryptors[{_identity!: id}] = frameCryptor;
      await frameCryptor.setKeyIndex(_keyProvider!.getLatestIndex(_identity!));
      await frameCryptor.setEnabled(_enabled);

      if (kIsWeb) {
        await frameCryptor.updateCodec(
          sender.track?.kind.toString().trim() == RtcTrackKind.video.kind
              ? _videoCodec.codec.toUpperCase()
              : _audioCodec.codec.toUpperCase(),
        );
      }
    } catch (e) {
      _logger.bug(e.toString());
    }
  }

  Future<void> addRtpReceiver({
    required RTCRtpReceiver receiver,
    required RTCVideoCodec codec,
    required bool enabled,
  }) async {
    if (_identity == null || _keyProvider == null) return;

    if (!codec.isSFrameSuported || !enabled) return;

    try {
      final String trackId = receiver.track?.id ?? '';
      final String id = '${receiver.track?.kind}_${trackId}_receiver';

      final frameCryptor = await _fcFactory.createFrameCryptorForRtpReceiver(
        participantId: _identity!,
        receiver: receiver,
        algorithm: _algorithm,
        keyProvider: _keyProvider!.keyProvider,
      );

      frameCryptor.onFrameCryptorStateChanged = (participantId, state) {
        _logger.log('Decryption: $participantId $state');
      };

      _frameCryptors[{_identity!: id}] = frameCryptor;
      await frameCryptor.setKeyIndex(_keyProvider!.getLatestIndex(_identity!));
      await frameCryptor.setEnabled(enabled);

      if (kIsWeb) {
        await frameCryptor.updateCodec(
          receiver.track?.kind == RtcTrackKind.video.kind
              ? codec.codec.toUpperCase()
              : _audioCodec.codec.toUpperCase(),
        );
      }
    } catch (e) {
      _logger.bug(e.toString());
    }
  }

  Future<void> ratchetKey({String? participantId, int? keyIndex}) async {
    if (participantId != null) {
      await _keyProvider?.ratchetKey(participantId, keyIndex);
    } else {
      await _keyProvider?.ratchetSharedKey(keyIndex: keyIndex);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    for (final frameCryptor in _frameCryptors.entries) {
      await frameCryptor.value.setEnabled(enabled);
    }
  }

  Future<void> dispose() async {
    final List<Future> futureTasks = [];
    for (final f in _frameCryptors.values) {
      futureTasks.add(f.dispose());
    }
    await Future.wait(futureTasks);

    _frameCryptors.clear();
  }
}

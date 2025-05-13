// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/video_quality.dart';
import 'package:waterbus_sdk/types/externals/models/audio_config.dart';
import 'package:waterbus_sdk/types/externals/models/video_config.dart';

part 'call_setting.freezed.dart';
part 'call_setting.g.dart';

@freezed
abstract class MediaConfig with _$MediaConfig {
  const factory MediaConfig({
    @Default(AudioConfig()) AudioConfig audioConfig,
    @Default(VideoConfig()) VideoConfig videoConfig,
    @Default(false) bool e2eeEnabled,
  }) = _MediaConfig;

  factory MediaConfig.fromJson(Map<String, Object?> json) =>
      _$MediaConfigFromJson(json);
}

extension CallSettingX on MediaConfig {
  Map<String, dynamic> get mediaConstraints {
    return {
      'audio': {
        'sampleRate': '48000',
        'sampleSize': '16',
        'channelCount': '1',
        ...(kIsWeb ? audioMandatory : {'mandatory': audioMandatory}),
      },
      'video': {
        'mandatory': videoConfig.videoQuality.videoProfile,
        'facingMode': 'user',
      },
    };
  }

  Map<String, dynamic> get audioMandatory {
    return {
      // Echo cancellation
      'googEchoCancellation': audioConfig.echoCancellationEnabled,
      'googEchoCancellation2': audioConfig.echoCancellationEnabled,
      'echoCancellation': audioConfig.echoCancellationEnabled,
      'googDAEchoCancellation': audioConfig.echoCancellationEnabled,

      // Noise suppression - reduces background noise
      'googNoiseSuppression': audioConfig.noiseSuppressionEnabled,
      'googNoiseSuppression2': audioConfig.noiseSuppressionEnabled,
      'noiseSuppression': audioConfig.noiseSuppressionEnabled,

      // Auto gain control - maintains consistent volume levels
      'googAutoGainControl': audioConfig.agcEnabled,
      'googAutoGainControl2': audioConfig.agcEnabled,
      'autoGainControl': audioConfig.agcEnabled,

      // Additional quality enhancements
      'googHighpassFilter': 'true',
      'googTypingNoiseDetection': 'true',
      'googAudioMirroring': 'false',

      'voiceIsolation': 'false',
    };
  }
}

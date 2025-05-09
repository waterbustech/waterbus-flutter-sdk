// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/index.dart';

part 'call_setting.freezed.dart';
part 'call_setting.g.dart';

@freezed
abstract class CallSetting with _$CallSetting {
  const factory CallSetting({
    @Default(false) bool isLowBandwidthMode,
    @Default(false) bool isAudioMuted,
    @Default(true) bool echoCancellationEnabled,
    @Default(true) bool noiseSuppressionEnabled,
    @Default(true) bool agcEnabled,
    @Default(false) bool isVideoMuted,
    @Default(false) bool e2eeEnabled,
    @Default(RTCVideoCodec.h264) RTCVideoCodec preferedCodec,
    @Default(VideoQuality.high) VideoQuality videoQuality,
    // @Default(VideoLayout.gridView) VideoLayout videoLayout,
  }) = _CallSetting;

  factory CallSetting.fromJson(Map<String, Object?> json) =>
      _$CallSettingFromJson(json);
}

extension CallSettingX on CallSetting {
  Map<String, dynamic> get mediaConstraints {
    return {
      'audio': {
        'sampleRate': '48000',
        'sampleSize': '16',
        'channelCount': '1',
        ...(kIsWeb ? audioMandatory : {'mandatory': audioMandatory}),
      },
      'video': {
        'mandatory': videoQuality.videoProfile,
        'facingMode': 'user',
      },
    };
  }

  Map<String, dynamic> get audioMandatory {
    return {
      // Echo cancellation
      'googEchoCancellation': echoCancellationEnabled,
      'googEchoCancellation2': echoCancellationEnabled,
      'echoCancellation': echoCancellationEnabled,
      'googDAEchoCancellation': echoCancellationEnabled,

      // Noise suppression - reduces background noise
      'googNoiseSuppression': noiseSuppressionEnabled,
      'googNoiseSuppression2': noiseSuppressionEnabled,
      'noiseSuppression': noiseSuppressionEnabled,

      // Auto gain control - maintains consistent volume levels
      'googAutoGainControl': agcEnabled,
      'googAutoGainControl2': agcEnabled,
      'autoGainControl': agcEnabled,

      // Additional quality enhancements
      'googHighpassFilter': 'true',
      'googTypingNoiseDetection': 'true',
      'googAudioMirroring': 'false',

      'voiceIsolation': 'false',
    };
  }
}

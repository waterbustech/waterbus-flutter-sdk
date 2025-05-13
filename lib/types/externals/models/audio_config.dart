import 'package:freezed_annotation/freezed_annotation.dart';

part "audio_config.freezed.dart";
part "audio_config.g.dart";

@freezed
abstract class AudioConfig with _$AudioConfig {
  const factory AudioConfig({
    @Default(false) bool isLowBandwidthMode,
    @Default(false) bool isAudioMuted,
    @Default(true) bool echoCancellationEnabled,
    @Default(true) bool noiseSuppressionEnabled,
    @Default(true) bool agcEnabled,
  }) = _AudioConfig;

  factory AudioConfig.fromJson(Map<String, Object?> json) =>
      _$AudioConfigFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AudioLevel {
  @JsonValue(0)
  kSilence(0),
  @JsonValue(0.025)
  kAudioLight(0.025),
  @JsonValue(0.015)
  kAudioStrong(0.15);

  const AudioLevel(this.threshold);

  final double threshold;
}

extension AudioLevelX on num {
  AudioLevel get level {
    if (this < AudioLevel.kAudioLight.threshold) {
      return AudioLevel.kSilence;
    }

    if (this >= AudioLevel.kAudioStrong.threshold) {
      return AudioLevel.kAudioStrong;
    }

    return AudioLevel.kAudioLight;
  }
}

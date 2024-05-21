enum AudioLevel {
  kSilence(0),
  kAudioLight(0.025),
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

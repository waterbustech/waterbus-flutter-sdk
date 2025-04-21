enum TrackType {
  webcam,
  screen;
}

extension TrackTypeX on int? {
  TrackType get trackType {
    return switch (this) {
      0 => TrackType.webcam,
      1 => TrackType.screen,
      _ => TrackType.webcam
    };
  }
}

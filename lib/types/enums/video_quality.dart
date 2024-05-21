enum VideoQuality {
  low('Data Saver'),
  auto('Balance'),
  high('High Quality');

  const VideoQuality(this.label);
  final String label;
}

extension VideoQualityX on VideoQuality {
  Map<String, dynamic> get videoProfile {
    switch (this) {
      // VGA
      case VideoQuality.low:
        return {
          'minHeight': '480',
          'minWidth': '640',
          'minFrameRate': '15',
          'frameRate': '15',
          'height': '720',
          'width': '1280',
        };
      // SVGA
      case VideoQuality.auto:
        return {
          'minHeight': '480',
          'minWidth': '640',
          'minFrameRate': '15',
          'frameRate': '15',
          'height': '600',
          'width': '800',
        };
      // HD - Full HD
      case VideoQuality.high:
        return {
          'minHeight': '720',
          'minWidth': '1280',
          'minFrameRate': '24',
          'frameRate': '24',
          'height': '1080',
          'width': '1920',
        };
    }
  }
}

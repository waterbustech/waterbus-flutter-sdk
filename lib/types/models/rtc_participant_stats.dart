class RtcParticipantStats {
  final num? frameWidth;
  final num? frameHeight;
  final num? bitrate;
  final num? jitter;
  final num? roundTripTime;
  final num? packetsLost;
  final num? fps;
  final num? framesSent;
  final num? framesReceived;
  RtcParticipantStats({
    this.frameWidth,
    this.frameHeight,
    this.bitrate,
    this.jitter,
    this.roundTripTime,
    this.packetsLost,
    this.fps,
    this.framesSent,
    this.framesReceived,
  });
}

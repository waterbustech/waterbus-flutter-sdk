import 'package:flutter/material.dart';
import 'package:video_view/video_view.dart';

class HlsView extends StatefulWidget {
  final String url;
  final bool mirror;

  const HlsView({
    super.key,
    required this.url,
    this.mirror = false,
  });

  @override
  State<HlsView> createState() => _HlsViewState();
}

class _HlsViewState extends State<HlsView> {
  late final VideoController _player;
  bool _showControls = true;
  bool _isHovering = false;
  double _volume = 1.0;
  bool _isMuted = false;

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();

    _player = VideoController(
      source: widget.url,
      cancelableNotification: true,
      autoPlay: true,
    );

    _player.showSubtitle.addListener(_update);
    _player.playbackState.addListener(_update);
    _player.position.addListener(_update);
    _player.overrideAudio.addListener(_update);
    _player.overrideSubtitle.addListener(_update);
    _player.videoSize.addListener(_update);
    _player.loading.addListener(_update);
    _player.error.addListener(_update);
    _player.mediaInfo.addListener(_update);

    // Auto-hide controls after 3 seconds
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isHovering) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _hideControlsAfterDelay();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours > 0 ? '${duration.inHours}:' : '';
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          _showControls = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
        _hideControlsAfterDelay();
      },
      child: GestureDetector(
        onTap: _showControlsTemporarily,
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video Player
              Transform(
                alignment: Alignment.center,
                transform: widget.mirror
                    ? (Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0))
                    : Matrix4.identity(),
                child: VideoView(controller: _player),
              ),
    
              // Loading indicator
              if (_player.loading.value)
                const CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 3,
                ),
    
              // Error message
              if (_player.error.value != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Playback Error',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _player.error.value!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    
              // Controls overlay
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top controls (optional - for live indicators, etc.)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (_player.mediaInfo.value?.duration == null ||
                                _player.mediaInfo.value!.duration == 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const Spacer(),
                          ],
                        ),
                      ),
    
                      const Spacer(),
    
                      // Bottom controls
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Progress bar
                            if (_player.mediaInfo.value?.duration != null &&
                                _player.mediaInfo.value!.duration > 0)
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                  activeTrackColor: Colors.red,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: Colors.red,
                                  overlayColor:
                                      Colors.red.withValues(alpha: 0.2),
                                ),
                                child: Slider(
                                  max:
                                      (_player.mediaInfo.value?.duration ?? 0)
                                          .toDouble(),
                                  value: _player.position.value
                                      .clamp(
                                        0,
                                        _player.mediaInfo.value?.duration ??
                                            0,
                                      )
                                      .toDouble(),
                                  onChanged: (value) =>
                                      _player.seekTo(value.toInt()),
                                ),
                              ),
    
                            const SizedBox(height: 8),
    
                            // Control buttons row
                            Row(
                              children: [
                                // Play/Pause button
                                IconButton(
                                  onPressed: () {
                                    if (_player.playbackState.value ==
                                        VideoControllerPlaybackState
                                            .playing) {
                                      _player.pause();
                                    } else {
                                      _player.play();
                                    }
                                  },
                                  icon: Icon(
                                    _player.playbackState.value ==
                                            VideoControllerPlaybackState
                                                .playing
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
    
                                // Rewind 10s
                                IconButton(
                                  onPressed: () => _player
                                      .seekTo(_player.position.value - 10000),
                                  icon: const Icon(
                                    Icons.replay_10,
                                    color: Colors.white,
                                  ),
                                ),
    
                                // Forward 10s
                                IconButton(
                                  onPressed: () => _player
                                      .seekTo(_player.position.value + 10000),
                                  icon: const Icon(
                                    Icons.forward_10,
                                    color: Colors.white,
                                  ),
                                ),
    
                                // Volume control
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isMuted = !_isMuted;
                                    });
                                  },
                                  icon: Icon(
                                    _isMuted
                                        ? Icons.volume_off
                                        : _volume > 0.5
                                            ? Icons.volume_up
                                            : Icons.volume_down,
                                    color: Colors.white,
                                  ),
                                ),
    
                                // Volume slider
                                SizedBox(
                                  width: 80,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 3,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Colors.white30,
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: _isMuted ? 0 : _volume,
                                      onChanged: (value) {
                                        setState(() {
                                          _volume = value;
                                          _isMuted = value == 0;
                                        });
                                      },
                                    ),
                                  ),
                                ),
    
                                // Time display
                                if (_player.mediaInfo.value?.duration !=
                                        null &&
                                    _player.mediaInfo.value!.duration > 0)
                                  Text(
                                    '${_formatDuration(Duration(milliseconds: _player.position.value))} / ${_formatDuration(Duration(milliseconds: _player.mediaInfo.value!.duration))}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
    
                                const Spacer(),
    
                                // Picture in Picture
                                IconButton(
                                  onPressed: () => _player.setDisplayMode(
                                    _player.displayMode.value ==
                                            VideoControllerDisplayMode
                                                .pictureInPicture
                                        ? VideoControllerDisplayMode.normal
                                        : VideoControllerDisplayMode
                                            .pictureInPicture,
                                  ),
                                  icon: const Icon(
                                    Icons.picture_in_picture_alt,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'Picture in Picture',
                                ),
    
                                // Fullscreen
                                IconButton(
                                  onPressed: () => _player.setDisplayMode(
                                    VideoControllerDisplayMode.fullscreen,
                                  ),
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'Fullscreen',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

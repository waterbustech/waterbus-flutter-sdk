import 'dart:async';

import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/models/track_quality.dart';
import 'package:waterbus_sdk/ui/waterbus_render_manager.dart';

class WaterbusMediaView extends StatefulWidget {
  final MediaSource mediaSource;
  final RTCVideoViewObjectFit objectFit;
  final bool mirror;

  /// Delay to prevent rapid quality changes
  final Duration debounceDelay;

  /// Minimum visibility fraction to consider widget visible
  final double visibilityThreshold;

  const WaterbusMediaView({
    super.key,
    required this.mediaSource,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirror = false,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.visibilityThreshold = 0.1, // 10% visible to trigger quality change
  });

  @override
  State<WaterbusMediaView> createState() => _WaterbusMediaViewState();
}

class _WaterbusMediaViewState extends State<WaterbusMediaView> {
  TrackQuality _quality = TrackQuality.low;
  bool _isVisible = true;
  Size _lastSize = Size.zero;
  Timer? _debounceTimer; // Timer to debounce quality updates
  double _visibilityFraction = 1.0; // Current visibility fraction (0.0 to 1.0)

  // Quality thresholds based on widget size
  static const double _highQualityThreshold = 800;
  static const double _mediumQualityThreshold = 400;
  static const double _aspectRatioThreshold =
      2.0; // For detecting unusual aspect ratios

  @override
  void initState() {
    super.initState();
    // Register initial quality after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerInitialQuality();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    WaterbusRenderManager().unregister(widget.mediaSource, context);
    super.dispose();
  }

  void _registerInitialQuality() {
    _updateQualityByState();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction > widget.visibilityThreshold;
    _visibilityFraction = info.visibleFraction;

    if (visible != _isVisible) {
      _isVisible = visible;
      _debouncedUpdateQuality();
    }
  }

  void _handleSizeChanged(BoxConstraints constraints) {
    final newSize = Size(constraints.maxWidth, constraints.maxHeight);

    // Only update if size change is significant
    if (_shouldUpdateForSizeChange(newSize)) {
      _lastSize = newSize;
      final newQuality = _estimateQuality(newSize);
      if (newQuality != _quality) {
        _quality = newQuality;
        _debouncedUpdateQuality();
      }
    }
  }

  // Check if size change is significant enough to trigger quality update
  bool _shouldUpdateForSizeChange(Size newSize) {
    if (_lastSize == Size.zero) return true;

    final widthDiff = (newSize.width - _lastSize.width).abs();
    final heightDiff = (newSize.height - _lastSize.height).abs();

    // Update if change is > 50px or > 10% of previous size
    return widthDiff > 50 ||
        heightDiff > 50 ||
        widthDiff > _lastSize.width * 0.1 ||
        heightDiff > _lastSize.height * 0.1;
  }

  // Debounce quality updates to prevent rapid changes
  void _debouncedUpdateQuality() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      if (mounted) {
        _updateQualityByState();
      }
    });
  }

  void _updateQualityByState() {
    final effectiveQuality = _calculateEffectiveQuality();
    WaterbusRenderManager()
        .register(widget.mediaSource, context, effectiveQuality);
  }

  // Calculate effective quality based on visibility and current quality
  TrackQuality _calculateEffectiveQuality() {
    if (!_isVisible) return TrackQuality.none;

    // Reduce quality if only partially visible (< 30%)
    if (_visibilityFraction < 0.3) {
      return _quality.index > 0
          ? TrackQuality.values[_quality.index - 1]
          : TrackQuality.none;
    }

    return _quality;
  }

  // Estimate required quality based on widget size
  TrackQuality _estimateQuality(Size size) {
    if (size.width <= 0 || size.height <= 0) return TrackQuality.none;

    final area = size.width * size.height;
    final aspectRatio = size.width / size.height;

    // Handle unusual aspect ratios (very wide or tall)
    if (aspectRatio > _aspectRatioThreshold ||
        aspectRatio < 1 / _aspectRatioThreshold) {
      if (size.width < 200 && size.height < 200) {
        return TrackQuality.low;
      }
    }

    // Use area for more accurate quality estimation
    if (area >= _highQualityThreshold * _highQualityThreshold) {
      return TrackQuality.high;
    }
    if (area >= _mediumQualityThreshold * _mediumQualityThreshold) {
      return TrackQuality.medium;
    }
    // Also check individual dimensions for medium quality
    if (size.width >= _mediumQualityThreshold ||
        size.height >= _mediumQualityThreshold) {
      return TrackQuality.medium;
    }

    return TrackQuality.low;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('media-view-${widget.mediaSource.hashCode}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _handleSizeChanged(constraints);
          return _videoView;
        },
      ),
    );
  }

  Widget get _videoView {
    // iOS uses platform view for video rendering
    if (WebRTC.platformIsIOS) {
      return RTCVideoPlatFormView(
        objectFit: widget.objectFit,
        mirror: widget.mirror,
        onViewReady: (controller) {
          widget.mediaSource.renderer = controller;
          widget.mediaSource.renderer?.srcObject = widget.mediaSource.stream;
        },
      );
    }

    // Check if renderer is properly initialized
    if (widget.mediaSource.renderer == null ||
        (widget.mediaSource.renderer is RTCVideoRenderer &&
            widget.mediaSource.renderer!.textureId == null)) {
      return const SizedBox();
    }

    // Use texture-based rendering for other platforms
    return RTCVideoView(
      widget.mediaSource.renderer as RTCVideoRenderer,
      key: widget.mediaSource.textureId == null
          ? null
          : Key(widget.mediaSource.textureId!.toString()),
      objectFit: widget.objectFit,
      mirror: widget.mirror,
    );
  }
}

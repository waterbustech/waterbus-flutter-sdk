import 'dart:async';

import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/ui/waterbus_render_manager.dart';

/// A Flutter widget that renders WebRTC video streams with adaptive quality based on
/// view visibility and size.
///
/// This widget automatically manages track quality subscriptions to optimize bandwidth
/// usage and performance. It subscribes to appropriate quality levels based on:
/// - Widget visibility in the viewport
/// - Widget size and aspect ratio
/// - User interaction patterns
///
/// ## Features:
/// - **Adaptive Quality**: Automatically adjusts video quality based on visibility and size
/// - **Visibility Detection**: Reduces quality when widget is partially visible or off-screen
/// - **Size-based Quality**: Higher quality for larger video views
/// - **Debounced Updates**: Prevents rapid quality changes that could impact performance
/// - **Error Handling**: Robust error handling with graceful fallbacks
///
/// ## Usage Example:
/// ```dart
/// WaterbusMediaView(
///   mediaSource: participant.mediaSource,
///   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
///   mirror: participant.isLocal,
///   debounceDelay: Duration(milliseconds: 300),
///   visibilityThreshold: 0.1,
///   minSizeChangeThreshold: 50.0,
///   enableAdaptiveQuality: true,
/// )
/// ```
///
/// ## Quality Levels:
/// - **None**: No video when widget is not visible
/// - **Low**: Basic quality for small or partially visible widgets
/// - **Medium**: Standard quality for medium-sized widgets
/// - **High**: Best quality for large, fully visible widgets
class WaterbusMediaView extends StatefulWidget {
  /// The media source containing the video stream to render
  final MediaSource mediaSource;

  /// How the video should fit within the widget bounds
  final RTCVideoViewObjectFit objectFit;

  /// Whether to mirror the video (useful for local camera views)
  final bool mirror;

  /// Delay to prevent rapid quality changes
  ///
  /// Prevents excessive quality updates when widget properties change rapidly.
  /// Default: 300ms
  final Duration debounceDelay;

  /// Minimum visibility fraction to consider widget visible
  ///
  /// Widgets with visibility below this threshold will receive no video.
  /// Range: 0.0 to 1.0. Default: 0.1 (10%)
  final double visibilityThreshold;

  /// Minimum size change to trigger quality update (in pixels)
  ///
  /// Prevents quality updates for minor size changes.
  /// Default: 50.0 pixels
  final double minSizeChangeThreshold;

  /// Whether to enable adaptive quality based on visibility
  ///
  /// When enabled, quality is reduced when widget is partially visible.
  /// Default: true
  final bool enableAdaptiveQuality;

  const WaterbusMediaView({
    super.key,
    required this.mediaSource,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirror = false,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.visibilityThreshold = 0.1, // 10% visible to trigger quality change
    this.minSizeChangeThreshold = 50.0,
    this.enableAdaptiveQuality = true,
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
  bool _isInitialized = false;

  final _logger = Logger('WaterbusMediaView');

  // Quality thresholds based on widget size
  static const double _highQualityThreshold = 1500;
  static const double _mediumQualityThreshold = 800;
  static const double _aspectRatioThreshold = 2.0;

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
    if (!mounted) return;

    try {
      _isInitialized = true;
      _updateQualityByState();
    } catch (e, stackTrace) {
      _logger.severe(
        'Error in _registerInitialQuality: $e\n$stackTrace',
      );
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted || !_isInitialized) return;

    try {
      final visible = info.visibleFraction > widget.visibilityThreshold;
      _visibilityFraction = info.visibleFraction;

      if (visible != _isVisible) {
        _isVisible = visible;
        _debouncedUpdateQuality();
      }
    } catch (e, stackTrace) {
      _logger.severe(
        'Error in _handleVisibilityChanged: $e\n$stackTrace',
      );
    }
  }

  void _handleSizeChanged(BoxConstraints constraints) {
    if (!mounted || !_isInitialized) return;

    try {
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
    } catch (e, stackTrace) {
      _logger.severe(
        'Error in _handleSizeChanged: $e\n$stackTrace',
      );
    }
  }

  // Check if size change is significant enough to trigger quality update
  bool _shouldUpdateForSizeChange(Size newSize) {
    if (_lastSize == Size.zero) return true;

    final widthDiff = (newSize.width - _lastSize.width).abs();
    final heightDiff = (newSize.height - _lastSize.height).abs();

    // Update if change is > threshold or > 10% of previous size
    return widthDiff > widget.minSizeChangeThreshold ||
        heightDiff > widget.minSizeChangeThreshold ||
        widthDiff > _lastSize.width * 0.1 ||
        heightDiff > _lastSize.height * 0.1;
  }

  // Debounce quality updates to prevent rapid changes
  void _debouncedUpdateQuality() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      if (mounted && _isInitialized) {
        _updateQualityByState();
      }
    });
  }

  void _updateQualityByState() {
    try {
      final effectiveQuality = _calculateEffectiveQuality();
      WaterbusRenderManager()
          .register(widget.mediaSource, context, effectiveQuality);
    } catch (e, stackTrace) {
      _logger.severe(
        'Error in _updateQualityByState: $e\n$stackTrace',
      );
    }
  }

  // Calculate effective quality based on visibility and current quality
  TrackQuality _calculateEffectiveQuality() {
    if (!_isVisible) return TrackQuality.none;

    if (!widget.enableAdaptiveQuality) {
      return _quality;
    }

    // Reduce quality if only partially visible (< 30%)
    if (_visibilityFraction < 0.3) {
      return _quality.index > 0
          ? TrackQuality.values[_quality.index - 1]
          : TrackQuality.none;
    }

    // Reduce quality if very small visibility (< 50%)
    if (_visibilityFraction < 0.5) {
      return _quality.index > 1
          ? TrackQuality.values[_quality.index - 2]
          : TrackQuality.low;
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
    try {
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
    } catch (e, stackTrace) {
      _logger.severe(
        'Error building video view: $e\n$stackTrace',
      );
      return const SizedBox();
    }
  }
}

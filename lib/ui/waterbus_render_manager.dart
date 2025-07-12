import 'dart:async';

import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/externals/models/media_source.dart';
import 'package:waterbus_sdk/types/internals/models/track_quality.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

class WaterbusRenderManager {
  static final WaterbusRenderManager _instance = WaterbusRenderManager._();
  factory WaterbusRenderManager() => _instance;
  WaterbusRenderManager._();

  final Map<MediaSource, List<_RenderEntry>> _sourceToEntries = {};
  final Map<MediaSource, Timer?> _updateTimers = {};
  final Map<MediaSource, TrackQuality> _lastQualityRequests = {};

  static const Duration _updateDelay = Duration(milliseconds: 200);

  void register(
    MediaSource source,
    BuildContext context,
    TrackQuality quality,
  ) {
    final entries = _sourceToEntries.putIfAbsent(source, () => []);

    entries.removeWhere((e) => e.context == context);

    entries.add(_RenderEntry(context: context, quality: quality));

    _debouncedUpdateSourceQuality(source);
  }

  void unregister(MediaSource source, BuildContext context) {
    final entries = _sourceToEntries[source];
    if (entries != null) {
      entries.removeWhere((e) => e.context == context);
      if (entries.isEmpty) {
        // Clean up all references when no more entries exist
        _sourceToEntries.remove(source);
        _updateTimers[source]?.cancel();
        _updateTimers.remove(source);
        _lastQualityRequests.remove(source);
      } else {
        _debouncedUpdateSourceQuality(source);
      }
    }
  }

  // Debounce quality updates to prevent rapid server requests
  void _debouncedUpdateSourceQuality(MediaSource source) {
    _updateTimers[source]?.cancel();
    _updateTimers[source] = Timer(_updateDelay, () {
      _updateSourceQuality(source);
    });
  }

  void _updateSourceQuality(MediaSource source) {
    final entries = _sourceToEntries[source] ?? [];
    final visibleEntries = entries.where((e) => e.isVisible).toList();

    if (visibleEntries.isEmpty) {
      _requestQualityChange(source, TrackQuality.none);
      return;
    }

    // Find the highest quality needed among all visible widgets
    final highest = visibleEntries.map((e) => e.quality).fold<TrackQuality>(
          TrackQuality.none,
          (prev, q) => q.priority > prev.priority ? q : prev,
        );

    // Only send request if quality has changed
    if (_lastQualityRequests[source] != highest) {
      _requestQualityChange(source, highest);
    }
  }

  void _requestQualityChange(MediaSource source, TrackQuality quality) {
    _lastQualityRequests[source] = quality;

    // Send signaling message to server
    source.setPreferredQuality(quality);

    // Log for debugging
    WaterbusLogger.instance.log(
      'Quality request for ${source.hashCode}: ${quality.name}',
    );
  }

  // Force update all sources (useful for network condition changes)
  void forceUpdateAllSources() {
    for (final source in _sourceToEntries.keys) {
      _updateSourceQuality(source);
    }
  }

  // Get current quality for debugging
  TrackQuality? getCurrentQuality(MediaSource source) {
    return _lastQualityRequests[source];
  }
}

class _RenderEntry {
  final BuildContext context;
  final TrackQuality quality;

  _RenderEntry({required this.context, required this.quality});

  bool get isVisible {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      return renderBox?.attached ?? false;
    } catch (e) {
      // Return false if context is invalid or widget is disposed
      return false;
    }
  }
}

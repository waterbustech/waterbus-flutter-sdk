import 'dart:async';

import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/externals/media/media_source.dart';
import 'package:waterbus_sdk/types/internals/rtc/track_quality.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

class WaterbusRenderManager {
  static final WaterbusRenderManager _instance = WaterbusRenderManager._();
  factory WaterbusRenderManager() => _instance;
  WaterbusRenderManager._();

  final Map<MediaSource, List<_RenderEntry>> _sourceToEntries = {};
  final Map<MediaSource, Timer?> _updateTimers = {};
  final Map<MediaSource, TrackQuality> _lastQualityRequests = {};
  final Map<MediaSource, DateTime> _lastRequestTimes = {};

  static const Duration _updateDelay = Duration(milliseconds: 200);
  static const Duration _minRequestInterval = Duration(milliseconds: 100);

  void register(
    MediaSource source,
    BuildContext context,
    TrackQuality quality,
  ) {
    try {
      final entries = _sourceToEntries.putIfAbsent(source, () => []);

      // Remove existing entry for this context
      entries.removeWhere((e) => e.context == context);

      // Add new entry
      entries.add(_RenderEntry(context: context, quality: quality));

      _debouncedUpdateSourceQuality(source);
    } catch (e, stackTrace) {
      WaterbusLogger.instance.bug(
        'Error registering render entry: $e\n$stackTrace',
      );
    }
  }

  void unregister(MediaSource source, BuildContext context) {
    try {
      final entries = _sourceToEntries[source];
      if (entries != null) {
        entries.removeWhere((e) => e.context == context);

        if (entries.isEmpty) {
          // Clean up all references when no more entries exist
          _sourceToEntries.remove(source);
          _updateTimers[source]?.cancel();
          _updateTimers.remove(source);
          _lastQualityRequests.remove(source);
          _lastRequestTimes.remove(source);
        } else {
          _debouncedUpdateSourceQuality(source);
        }
      }
    } catch (e, stackTrace) {
      WaterbusLogger.instance.bug(
        'Error unregistering render entry: $e\n$stackTrace',
      );
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
    try {
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

      // Only send request if quality has changed and enough time has passed
      final lastRequestTime = _lastRequestTimes[source];
      final now = DateTime.now();

      if (_lastQualityRequests[source] != highest &&
          (lastRequestTime == null ||
              now.difference(lastRequestTime) >= _minRequestInterval)) {
        _requestQualityChange(source, highest);
      }
    } catch (e, stackTrace) {
      WaterbusLogger.instance.bug(
        'Error updating source quality: $e\n$stackTrace',
      );
    }
  }

  void _requestQualityChange(MediaSource source, TrackQuality quality) {
    try {
      _lastQualityRequests[source] = quality;
      _lastRequestTimes[source] = DateTime.now();

      // Send signaling message to server
      source.setPreferredQuality(quality);
    } catch (e, stackTrace) {
      WaterbusLogger.instance.bug(
        'Error requesting quality change: $e\n$stackTrace',
      );
    }
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

  // Get statistics for debugging
  Map<String, dynamic> getStatistics() {
    return {
      'totalSources': _sourceToEntries.length,
      'totalEntries': _sourceToEntries.values
          .map((entries) => entries.length)
          .fold(0, (sum, count) => sum + count),
      'activeTimers': _updateTimers.length,
      'lastRequests': _lastQualityRequests.length,
    };
  }

  // Clean up all resources
  void dispose() {
    for (final timer in _updateTimers.values) {
      timer?.cancel();
    }
    _sourceToEntries.clear();
    _updateTimers.clear();
    _lastQualityRequests.clear();
    _lastRequestTimes.clear();
  }
}

class _RenderEntry {
  final BuildContext context;
  final TrackQuality quality;

  _RenderEntry({required this.context, required this.quality});

  bool get isVisible {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) return false;

      // Check if the widget is actually visible in the viewport
      final size = renderBox.size;
      return size.width > 0 && size.height > 0;
    } catch (e) {
      // Return false if context is invalid or widget is disposed
      return false;
    }
  }

  @override
  String toString() {
    return '_RenderEntry(quality: $quality, isVisible: $isVisible)';
  }
}

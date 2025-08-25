import 'package:h264_profile_level_id/h264_profile_level_id.dart';
import 'package:sdp_transform/sdp_transform.dart';

import 'package:waterbus_sdk/types/externals/media/rtc_video_codec.dart';
import 'package:waterbus_sdk/utils/codec_selector.dart';

const ddExtensionURI =
    'https://aomediacodec.github.io/av1-rtp-spec/#dependency-descriptor-rtp-header-extension';
const startBitrateForSVC = 0.7;

extension SdpExtension on String {
  String optimizeSdp({
    RTCVideoCodec codec = RTCVideoCodec.h264,
    bool isP2P = false,
    int maxBitrate = 3000000,
  }) {
    return setPreferredCodec(codec: codec, isP2P: isP2P, maxBitrate: maxBitrate)
        .enableAudioDTX();
  }

  String enableAudioDTX() {
    return replaceAll(
      'a=fmtp:111 minptime=10;useinbandfec=1',
      'a=fmtp:111 minptime=10;useinbandfec=1;usedtx=1',
    );
  }

  String updateH264Profile() {
    final profileLevelId = ProfileLevelId(
      profile: H264Utils.ProfileConstrainedBaseline,
      level: H264Utils.Level3_1,
    );
    final session = parse(this);

    // Update only for video media lines
    for (final media in session['media']) {
      if (media['type'] == 'video') {
        // Update all fmtp lines with profile-level-id
        if (media['fmtp'] != null && media['fmtp'] is List) {
          for (final fmtp in media['fmtp']) {
            fmtp['config'] = fmtp['config'].replaceAll(
              RegExp('profile-level-id=[0-9A-Fa-f]+'),
              'profile-level-id=${H264Utils.profileLevelIdToString(profileLevelId)}',
            );
          }
        }
      }
    }

    return write(session, null);
  }

  /// Check if codec is SVC (VP9 or AV1)
  bool _isSVCCodec(String? codec) {
    if (codec == null) return false;
    final codecLower = codec.toLowerCase();
    return codecLower == 'vp9' || codecLower == 'av1';
  }

  /// Ensure Dependency Descriptor extension is present for SVC codecs
  String _ensureVideoDDExtensionForSVC(Map<String, dynamic> session) {
    if (session['media'] == null) return write(session, null);

    for (final media in session['media']) {
      if (media['type'] != 'video') continue;

      // Check if this media uses SVC codec
      final codec = media['rtp']?[0]?['codec']?.toLowerCase();
      if (!_isSVCCodec(codec)) continue;

      var maxID = 0;
      bool ddFound = false;
      List<dynamic>? ext = media['ext'];

      if (ext != null) {
        for (final e in ext) {
          if (e['uri'] == ddExtensionURI) {
            ddFound = true;
            continue;
          }
          if (e['value'] != null && e['value'] > maxID) {
            maxID = e['value'];
          }
        }
      } else {
        media['ext'] = <dynamic>[];
        ext = media['ext'];
      }

      // Add dependency descriptor extension if not found
      if (!ddFound) {
        ext!.add({
          'value': maxID + 1,
          'uri': ddExtensionURI,
        });
      }
    }

    return write(session, null);
  }

  /// Optimize SVC codec bitrate settings
  String _optimizeSVCBitrate(Map<String, dynamic> session, int? maxBitrate) {
    if (session['media'] == null || maxBitrate == null) {
      return write(session, null);
    }

    for (final media in session['media']) {
      if (media['type'] != 'video') continue;

      final codec = media['rtp']?[0]?['codec'];
      if (!_isSVCCodec(codec)) continue;

      // Find the codec payload
      var codecPayload = 0;
      if (media['rtp'] != null) {
        for (final rtp in media['rtp']) {
          if (rtp['codec']?.toLowerCase() == codec?.toLowerCase()) {
            codecPayload = rtp['payload'];
            break;
          }
        }
      }

      if (codecPayload == 0) continue;

      // Update fmtp with start bitrate
      if (media['fmtp'] != null) {
        for (final fmtp in media['fmtp']) {
          if (fmtp['payload'] == codecPayload) {
            String config = fmtp['config'] ?? '';

            // Calculate start bitrate (70% of max for SVC)
            final startBitrate = (maxBitrate * startBitrateForSVC).toInt();

            // Add x-google-start-bitrate if not present
            if (!config.contains('x-google-start-bitrate')) {
              if (config.isNotEmpty && !config.endsWith(';')) {
                config += ';';
              }
              config += 'x-google-start-bitrate=$startBitrate';
              fmtp['config'] = config;
            }
            break;
          }
        }
      }
    }

    return write(session, null);
  }

  String setPreferredCodec({
    RTCVideoCodec codec = RTCVideoCodec.h264,
    bool isP2P = false,
    int? maxBitrate,
  }) {
    final capSel = CodecCapabilitySelector(this);

    final vcaps = capSel.getCapabilities('video');
    if (vcaps != null) {
      final List codecsFiltered = vcaps.codecs
          .where((e) => (e['codec'] as String).toLowerCase() == codec.codec)
          .toList();

      if (codecsFiltered.isEmpty) return this;

      vcaps.codecs = codecsFiltered;
      vcaps.setCodecPreferences('video', vcaps.codecs);
      capSel.setCapabilities(vcaps);
    }

    String result = capSel.sdp();

    // Parse the SDP for further processing
    final session = parse(result);

    if (codec == RTCVideoCodec.h264) {
      // Apply H264 specific optimizations
      result = result.updateH264Profile();
    } else if (_isSVCCodec(codec.codec)) {
      // Apply SVC specific optimizations
      result = _ensureVideoDDExtensionForSVC(session);
      if (maxBitrate != null) {
        final sessionAfterDD = parse(result);
        result = _optimizeSVCBitrate(sessionAfterDD, maxBitrate);
      }
    }

    return result;
  }
}

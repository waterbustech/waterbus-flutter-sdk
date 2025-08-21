import 'package:h264_profile_level_id/h264_profile_level_id.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:waterbus_sdk/types/externals/media/rtc_video_codec.dart';
import 'package:waterbus_sdk/utils/codec_selector.dart';

extension SdpX on String {
  String optimizeSdp({
    RTCVideoCodec codec = RTCVideoCodec.h264,
    bool isP2P = false,
  }) {
    return setPreferredCodec(codec: codec, isP2P: isP2P).enableAudioDTX();
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

  String setPreferredCodec({
    RTCVideoCodec codec = RTCVideoCodec.h264,
    bool isP2P = false,
  }) {
    final capSel = CodecCapabilitySelector(this);
    final vcaps = capSel.getCapabilities('video');

    if (vcaps != null) {
      final List preferred = vcaps.codecs
          .where((e) => (e['codec'] as String).toLowerCase() == codec.codec)
          .toList();

      if (preferred.isEmpty) {
        return this;
      }

      final List reordered = [
        ...preferred,
        ...vcaps.codecs.where(
          (e) => (e['codec'] as String).toLowerCase() != codec.codec,
        ),
      ];

      vcaps.setCodecPreferences('video', reordered);
      capSel.setCapabilities(vcaps);
    }

    if (codec == RTCVideoCodec.h264) {
      return capSel.sdp().updateH264Profile();
    }

    return capSel.sdp();
  }
}

import 'package:h264_profile_level_id/h264_profile_level_id.dart';
import 'package:sdp_transform/sdp_transform.dart';

import 'package:waterbus_sdk/types/externals/enums/index.dart';
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
    session['media'][0]['profile-level-id'] = H264Utils.profileLevelIdToString(
      profileLevelId,
    );
    final newSdp = write(session, null);

    return newSdp;
  }

  String setPreferredCodec({
    RTCVideoCodec codec = RTCVideoCodec.h264,
    bool isP2P = false,
  }) {
    final capSel = CodecCapabilitySelector(this);

    final vcaps = capSel.getCapabilities('video');
    if (vcaps != null) {
      final List codecsFiltered = vcaps.codecs
          .where((e) => (e['codec'] as String).toLowerCase() == codec.codec)
          .toList();

      if (codecsFiltered.isEmpty) return this; // Prefered codec not supported

      vcaps.codecs = codecsFiltered;
      vcaps.setCodecPreferences('video', vcaps.codecs);
      capSel.setCapabilities(vcaps);
    }

    if (codec == RTCVideoCodec.h264) {
      return capSel.sdp().updateH264Profile();
    }

    return capSel.sdp();
  }
}

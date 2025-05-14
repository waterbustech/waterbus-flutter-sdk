import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'participant_e2ee_config.freezed.dart';

@freezed
abstract class ParticipantE2eeConfig with _$ParticipantE2eeConfig {
  const factory ParticipantE2eeConfig({
    required RTCRtpReceiver receiver,
    required String targetId,
    required bool isEnabled,
  }) = _ParticipantE2eeConfig;
}

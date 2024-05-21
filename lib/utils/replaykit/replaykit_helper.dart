import 'package:replay_kit_launcher/replay_kit_launcher.dart';

class ReplayKitHelper {
  final String broadcastExtName = 'BroadcastWaterbus';

  void openReplayKit() {
    ReplayKitLauncher.launchReplayKitBroadcast(broadcastExtName);
  }
}

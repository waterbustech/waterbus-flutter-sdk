import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_emiter_interface.dart';
import 'package:waterbus_sdk/core/whiteboard/white_board_interfaces.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

@Injectable(as: WhiteBoardManager)
class WhiteBoardManagerIpml extends WhiteBoardManager {
  final List<DrawModel> localWhiteBoard = [];
  final List<DrawModel> remoteWhiteBoard = [];
  final List<DrawModel> historyWhiteBoard = [];

  final WaterbusWebRTCManager _rtcManager;
  final SocketEmiter _socketEmiter;
  WhiteBoardManagerIpml(this._rtcManager, this._socketEmiter);

  String? get roomId => _rtcManager.roomId;

  @override
  Future<void> startWhiteBoard() async {
    if (roomId == null) return;

    _socketEmiter.startWhiteBoard(roomId!);
  }

  @override
  Future<void> updateWhiteBoard(
    DrawModel draw,
    DrawActionEnum action,
  ) async {
    if (roomId == null) return;

    historyWhiteBoard.add(draw);
    localWhiteBoard.add(draw);

    _socketEmiter.updateWhiteBoard(roomId!, action.action, draw);
    _emitWhiteBoard();
  }

  @override
  Future<void> cleanWhiteBoard({bool isLocal = true}) async {
    if (roomId == null) return;

    localWhiteBoard.clear();
    remoteWhiteBoard.clear();
    historyWhiteBoard.clear();

    if (isLocal) _socketEmiter.cleanWhiteBoard(roomId!);
    _emitWhiteBoard();
  }

  @override
  Future<void> undoWhiteBoard() async {
    if (localWhiteBoard.isEmpty || roomId == null) return;

    final undoModel = localWhiteBoard.last;
    localWhiteBoard.removeLast();

    _socketEmiter.updateWhiteBoard(
      roomId!,
      DrawActionEnum.updateRemove.action,
      undoModel,
    );
    _emitWhiteBoard();
  }

  @override
  Future<void> redoWhiteBoard() async {
    if (historyWhiteBoard.length == localWhiteBoard.length || roomId == null) {
      return;
    }

    final redoModel = historyWhiteBoard[localWhiteBoard.length];
    localWhiteBoard.add(redoModel);

    _socketEmiter.updateWhiteBoard(
      roomId!,
      DrawActionEnum.updateAdd.action,
      redoModel,
    );
    _emitWhiteBoard();
  }

  @override
  void onRemoteBoardChanged(List<DrawModel> paints, DrawActionEnum action) {
    switch (action) {
      case DrawActionEnum.updateAdd:
        remoteWhiteBoard.addAll(paints);
        _emitWhiteBoard();
        break;
      case DrawActionEnum.updateRemove:
        remoteWhiteBoard.removeWhere((element) => paints.contains(element));
        _emitWhiteBoard();
        break;
      default:
        break;
    }
  }

  Future<void> _emitWhiteBoard() async {
    final props = [...localWhiteBoard, ...remoteWhiteBoard];
    props.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    WaterbusSdk.onDrawChanged?.call(props);
  }
}

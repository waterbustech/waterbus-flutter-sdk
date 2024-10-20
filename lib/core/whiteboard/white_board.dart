import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_emiter_interface.dart';
import 'package:waterbus_sdk/core/whiteboard/white_board_interfaces.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

@LazySingleton(as: WhiteBoardManager)
class WhiteBoardManagerIpml extends WhiteBoardManager {
  final List<DrawModel> _localPaints = [];
  final List<DrawModel> _remotePaints = [];
  final List<DrawModel> _cachedPaints = [];

  final WaterbusWebRTCManager _rtcManager;
  final SocketEmiter _socketEmiter;
  WhiteBoardManagerIpml(this._rtcManager, this._socketEmiter);

  String? get roomId => _rtcManager.roomId;

  @override
  Future<void> startWhiteBoard() async {
    if (roomId == null) return;

    cleanWhiteBoard(shouldEmit: false);
    _socketEmiter.startWhiteBoard(roomId!);
  }

  @override
  Future<void> updateWhiteBoard(
    DrawModel draw,
    DrawActionEnum action,
  ) async {
    if (roomId == null) return;

    _cachedPaints.add(draw);
    _localPaints.add(draw);

    _socketEmiter.updateWhiteBoard(roomId!, action.action, draw);
    _emitWhiteBoard();
  }

  @override
  Future<void> cleanWhiteBoard({bool shouldEmit = true}) async {
    if (roomId == null) return;

    _localPaints.clear();
    _remotePaints.clear();
    _cachedPaints.clear();

    if (shouldEmit) _socketEmiter.cleanWhiteBoard(roomId!);
    _emitWhiteBoard();
  }

  @override
  Future<void> undoWhiteBoard() async {
    if (_localPaints.isEmpty || roomId == null) return;

    final undoModel = _localPaints.last;
    _localPaints.removeLast();

    _socketEmiter.updateWhiteBoard(
      roomId!,
      DrawActionEnum.updateRemove.action,
      undoModel,
    );
    _emitWhiteBoard();
  }

  @override
  Future<void> redoWhiteBoard() async {
    if (_cachedPaints.length == _localPaints.length || roomId == null) {
      return;
    }

    final redoModel = _cachedPaints[_localPaints.length];
    _localPaints.add(redoModel);

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
        _remotePaints.addAll(paints);
        _emitWhiteBoard();
        break;
      case DrawActionEnum.updateRemove:
        _remotePaints.removeWhere((element) => paints.contains(element));
        _emitWhiteBoard();
        break;
      default:
        break;
    }
  }

  Future<void> _emitWhiteBoard() async {
    final props = [..._localPaints, ..._remotePaints];
    props.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    WaterbusSdk.onDrawChanged?.call(props);
  }
}

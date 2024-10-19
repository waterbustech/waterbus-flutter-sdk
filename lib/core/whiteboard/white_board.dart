import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus_sdk/constants/socket_events.dart';
import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/core/whiteboard/white_board_interfaces.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/injection/injection_container.dart';
import 'package:waterbus_sdk/types/enums/draw_socket_enum.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

@Injectable(as: WhiteBoardManager)
class WhiteBoardManagerIpml extends WhiteBoardManager {
  final List<DrawModel> localWhiteBoard = [];
  final List<DrawModel> remoteWhiteBoard = [];
  final List<DrawModel> historyWhiteBoard = [];
  final WaterbusWebRTCManager _rtcManager;
  WhiteBoardManagerIpml(
    this._rtcManager,
  );
  @override
  Future<void> startWhiteBoardCSS() async {
    _socket
        ?.emit(SocketEvent.startWhiteBoardCSS, {'roomId': _rtcManager.roomId});
  }

  @override
  Future<void> updateWhiteBoardCSS(
    DrawModel draw,
    DrawActionEnum action,
  ) async {
    historyWhiteBoard.add(draw);
    localWhiteBoard.add(draw);
    _socket?.emit(SocketEvent.updateWhiteBoardCSS, {
      'roomId': _rtcManager.roomId,
      'action': action.str,
      'paints': [draw.toMap()],
    });
    final props = [...localWhiteBoard, ...remoteWhiteBoard];
    WaterbusSdk.onDrawChanged?.call(props);
  }

  @override
  Future<void> cleanWhiteBoardCSS() async {
    localWhiteBoard.clear();
    remoteWhiteBoard.clear();
    historyWhiteBoard.clear();
    _socket
        ?.emit(SocketEvent.cleanWhiteBoardCSS, {'roomId': _rtcManager.roomId});
    final props = [...localWhiteBoard, ...remoteWhiteBoard];
    WaterbusSdk.onDrawChanged?.call(props);
  }

  @override
  Future<void> undoWhiteBoardCSS() async {
    if (localWhiteBoard.isNotEmpty) {
      final undoModel = localWhiteBoard.last;
      localWhiteBoard.removeLast();
      _socket?.emit(SocketEvent.updateWhiteBoardCSS, {
        'roomId': _rtcManager.roomId,
        'action': DrawActionEnum.updateRemove.str,
        'paints': [undoModel.toMap()],
      });
      final props = [...localWhiteBoard, ...remoteWhiteBoard];
      WaterbusSdk.onDrawChanged?.call(props);
    }
  }

  @override
  Future<void> redoWhiteBoardCSS() async {
    if (historyWhiteBoard.length != localWhiteBoard.length) {
      final redoModel = historyWhiteBoard[localWhiteBoard.length];
      localWhiteBoard.add(redoModel);

      _socket?.emit(SocketEvent.updateWhiteBoardCSS, {
        'roomId': _rtcManager.roomId,
        'action': DrawActionEnum.updateAdd.str,
        'paints': [redoModel.toMap()],
      });
    }
    final props = [...localWhiteBoard, ...remoteWhiteBoard];
    WaterbusSdk.onDrawChanged?.call(props);
  }

  @override
  Future<void> startWhiteBoardSSC(List<DrawModel> drawList) async {}

  @override
  Future<void> updateWhiteBoardAddSSC(List<DrawModel> drawList) async {
    remoteWhiteBoard.addAll(drawList);
    callBackWhiteBoard();
  }

  @override
  Future<void> updateWhiteBoardRemoveSSC(List<DrawModel> drawList) async {
    remoteWhiteBoard.removeWhere((element) => drawList.contains(element));
    callBackWhiteBoard();
  }

  @override
  Future<void> cleanWhiteBoardSSC() async {
    localWhiteBoard.clear();
    remoteWhiteBoard.clear();
    historyWhiteBoard.clear();
    callBackWhiteBoard();
  }

  @override
  Future<void> callBackWhiteBoard() async {
    final props = [...localWhiteBoard, ...remoteWhiteBoard];
    props.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    WaterbusSdk.onDrawChanged?.call(props);
  }

  Socket? get _socket => getIt<SocketHandler>().socket;
}

import 'package:waterbus_sdk/types/enums/draw_socket_enum.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

abstract class WhiteBoardManager {
  // Emit : CSS
  Future<void> startWhiteBoardCSS();
  Future<void> updateWhiteBoardCSS(
    DrawModel draw,
    DrawActionEnum action,
  );
  Future<void> cleanWhiteBoardCSS();
  Future<void> undoWhiteBoardCSS();
  Future<void> redoWhiteBoardCSS();

  // Listen: SSC
  Future<void> startWhiteBoardSSC(List<DrawModel> drawList);
  Future<void> updateWhiteBoardAddSSC(List<DrawModel> drawList);
  Future<void> updateWhiteBoardRemoveSSC(List<DrawModel> drawList);
  Future<void> cleanWhiteBoardSSC();

  // Callback
  Future<void> callBackWhiteBoard();
}

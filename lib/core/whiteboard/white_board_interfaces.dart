import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

abstract class WhiteBoardManager {
  void startWhiteBoard();
  void updateWhiteBoard(DrawModel draw, DrawActionEnum action);
  void undoWhiteBoard();
  void redoWhiteBoard();
  void cleanWhiteBoard({bool shouldEmit = true});

  void onRemoteBoardChanged(List<DrawModel> paints, DrawActionEnum action) {}
}

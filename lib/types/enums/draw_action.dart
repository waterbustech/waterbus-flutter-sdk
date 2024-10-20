enum DrawActionEnum {
  updateAdd('add'),
  updateRemove('remove');

  const DrawActionEnum(this.action);

  final String action;
}

extension DrawActionEnumX on String {
  DrawActionEnum get drawAction {
    final int index =
        DrawActionEnum.values.indexWhere((type) => type.action == this);

    if (index == -1) return DrawActionEnum.updateAdd;

    return DrawActionEnum.values[index];
  }
}

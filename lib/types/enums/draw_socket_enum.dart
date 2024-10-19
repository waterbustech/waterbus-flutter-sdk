enum DrawActionEnum {
  start('start'),
  updateAdd('add'),
  updateRemove('remove'),
  delete('delete');

  const DrawActionEnum(this.str);

  final String str;
}

extension DrawActionEnumX on String {
  DrawActionEnum get drawSocketEnum {
    final int index =
        DrawActionEnum.values.indexWhere((type) => type.str == this);

    if (index == -1) return DrawActionEnum.start;

    return DrawActionEnum.values[index];
  }
}

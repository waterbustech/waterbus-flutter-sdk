import 'package:collection/collection.dart';

enum ChatStatusEnum {
  invite(0),
  join(2);

  const ChatStatusEnum(this.status);

  final int status;
}

extension ChatStatusEnumX on int {
  ChatStatusEnum get getChatStatusEnum {
    return ChatStatusEnum.values
            .firstWhereOrNull((status) => status.status == this) ??
        ChatStatusEnum.join;
  }
}

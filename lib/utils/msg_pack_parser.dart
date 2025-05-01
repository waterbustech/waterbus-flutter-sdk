// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:msgpack_dart/msgpack_dart.dart' as m2;
import 'package:socket_io_common/socket_io_common.dart';

class MsgPackEncoder extends Encoder {
  @override
  List<Object?> encode(Object? obj) {
    final encoded = m2.serialize(obj);
    return [encoded];
  }
}

class MsgPackDecoder extends Decoder {
  @override
  add(obj) {
    if (obj is String) {
      final packet = <String, dynamic>{'type': num.parse(obj[8]), 'nsp': '/'};

      emit('decoded', packet);
    } else if (obj is Uint8List) {
      final packet = m2.deserialize(obj);

      emit('decoded', packet);
    } else {
      return super.add(obj);
    }
  }
}

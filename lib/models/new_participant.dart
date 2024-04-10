// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

class UserModel {
  final int id;
  final String userName;
  final String fullName;
  final String? avatar;
  UserModel({
    required this.id,
    required this.userName,
    required this.fullName,
    this.avatar,
  });

  UserModel copyWith({
    int? id,
    String? userName,
    String? fullName,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      userName: map['userName'] as String,
      fullName: map['fullName'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, fullName: $fullName, avatar: $avatar)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        avatar.hashCode;
  }
}

class NewParticipant {
  final int id;
  final UserModel user;
  NewParticipant({
    required this.id,
    required this.user,
  });

  NewParticipant copyWith({
    int? id,
    UserModel? user,
  }) {
    return NewParticipant(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
    };
  }

  factory NewParticipant.fromMap(Map<String, dynamic> map) {
    return NewParticipant(
      id: map['id'] as int,
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewParticipant.fromJson(String source) =>
      NewParticipant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NewParticipant(id: $id, user: $user)';

  @override
  bool operator ==(covariant NewParticipant other) {
    if (identical(this, other)) return true;

    return other.id == id && other.user == user;
  }

  @override
  int get hashCode => id.hashCode ^ user.hashCode;
}

import 'dart:convert';

class Subtitle {
  final String participant;
  final String content;
  Subtitle({
    required this.participant,
    required this.content,
  });

  Subtitle copyWith({
    String? participant,
    String? content,
  }) {
    return Subtitle(
      participant: participant ?? this.participant,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participant': participant,
      'content': content,
    };
  }

  factory Subtitle.fromMap(Map<String, dynamic> map) {
    return Subtitle(
      participant: map['participant'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subtitle.fromJson(String source) =>
      Subtitle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Subtitle(participant: $participant, content: $content)';

  @override
  bool operator ==(covariant Subtitle other) {
    if (identical(this, other)) return true;

    return other.participant == participant && other.content == content;
  }

  @override
  int get hashCode => participant.hashCode ^ content.hashCode;
}

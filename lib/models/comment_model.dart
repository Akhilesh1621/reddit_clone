class Comment {
  final String id;
  final String text;
  final String postid;
  final String username;
  final String porfilePic;
  final DateTime createdAt;
  Comment({
    required this.id,
    required this.text,
    required this.postid,
    required this.username,
    required this.porfilePic,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? text,
    String? postid,
    String? username,
    String? porfilePic,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      postid: postid ?? this.postid,
      username: username ?? this.username,
      porfilePic: porfilePic ?? this.porfilePic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'postid': postid,
      'username': username,
      'porfilePic': porfilePic,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      postid: map['postid'] ?? '',
      username: map['username'] ?? '',
      porfilePic: map['porfilePic'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, postid: $postid, username: $username, porfilePic: $porfilePic, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.postid == postid &&
        other.username == username &&
        other.porfilePic == porfilePic &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        postid.hashCode ^
        username.hashCode ^
        porfilePic.hashCode ^
        createdAt.hashCode;
  }
}

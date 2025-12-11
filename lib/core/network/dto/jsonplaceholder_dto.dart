/// DTO для ответов JSONPlaceholder API

/// DTO для поста
class JsonPlaceholderPostDto {
  final int id;
  final int userId;
  final String title;
  final String body;

  JsonPlaceholderPostDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory JsonPlaceholderPostDto.fromJson(Map<String, dynamic> json) {
    return JsonPlaceholderPostDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

/// DTO для комментария
class JsonPlaceholderCommentDto {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  JsonPlaceholderCommentDto({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory JsonPlaceholderCommentDto.fromJson(Map<String, dynamic> json) {
    return JsonPlaceholderCommentDto(
      id: json['id'] as int,
      postId: json['postId'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}


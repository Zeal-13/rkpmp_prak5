
class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final String? avatarUrl; // Добавьте это поле

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    this.avatarUrl, // Опциональное поле
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

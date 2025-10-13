class User {
  final String id;
  String name;
  String email;
  String role;

  User({required this.id, required this.name, required this.email, required this.role});

  User copyWith({String? name, String? email, String? role}) {
    return User(id: id, name: name ?? this.name, email: email ?? this.email, role: role ?? this.role);
  }
}

class User {
  int? id;
  String username;
  String email;
  String password;
  String role;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  // Pour insérer dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Pour lire depuis la base de données
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}

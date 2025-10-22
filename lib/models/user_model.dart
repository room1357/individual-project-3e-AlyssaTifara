import 'package:uuid/uuid.dart';

class User {
  final String id;
  String fullName;
  String email;
  final String username; // username should remain immutable
  String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  }) : id = const Uuid().v4();

  // Copy with method for updating user data
  User copyWith({
    String? fullName,
    String? email,
    String? password,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: this.username, // username cannot be changed
      password: password ?? this.password,
    );
  }
}

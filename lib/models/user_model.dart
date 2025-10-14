import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  }) : id = const Uuid().v4();
}

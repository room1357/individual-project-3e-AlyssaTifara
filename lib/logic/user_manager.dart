import 'package:pemrograman_mobile/models/user_model.dart';

class UserManager {
  static User? currentUser; // Track the currently logged-in user

  final List<User> _users = [
    User(
      fullName: 'christhor',
      email: 'chris@example.com',
      username: 'christhor',
      password: '123',
    ),
    User(
      fullName: 'Oka',
      email: 'oka@example.com',
      username: 'oka',
      password: '123',
    ),
    User(
      fullName: 'Miki',
      email: 'miki@example.com',
      username: 'miki',
      password: '123',
    ),
  ];

  void registerUser(String fullName, String email, String username, String password) {
    final newUser = User(
      fullName: fullName,
      email: email,
      username: username,
      password: password,
    );
    _users.add(newUser);
  }

  User? loginUser(String username, String password) {
    for (var user in _users) {
      if (user.username == username && user.password == password) {
        currentUser = user; // Set current user on successful login
        return user;
      }
    }
    return null;
  }

  void updateUser(String username, String fullName, String email, String password) {
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].username == username) {
        _users[i] = _users[i].copyWith(
          fullName: fullName,
          email: email,
          password: password,
        );
        break;
      }
    }
  }

  // Get all users except the current user for sharing expenses
  List<User> getAllUsersExceptCurrent() {
    if (currentUser == null) return [];
    return _users.where((user) => user.id != currentUser!.id).toList();
  }

  // Get all users (for admin purposes)
  List<User> getAllUsers() {
    return _users;
  }

  // Get user by ID
  User? getUserById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }
}

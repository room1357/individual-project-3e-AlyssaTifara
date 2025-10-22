import 'package:pemrograman_mobile/models/user_model.dart';

class UserManager {
  final List<User> _users = [
    User(
      fullName: 'christhor',
      email: 'chris@example.com',
      username: 'christhor',
      password: '1234567890',
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
}

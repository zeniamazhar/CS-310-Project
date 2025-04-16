class UserData {
  // email -> { name, username, password }
  static final Map<String, Map<String, String>> _registeredUsers = {};
  static String? _loggedInEmail;

  static bool registerUser({
    required String email,
    required String password,
    required String name,
    required String username,
  }) {
    if (_registeredUsers.containsKey(email)) {
      return false; // Already exists
    }

    _registeredUsers[email] = {
      'name': name,
      'username': username,
      'password': password,
    };
    return true;
  }

  static bool authenticate(String email, String password) {
    if (_registeredUsers.containsKey(email)) {
      return _registeredUsers[email]!['password'] == password;
    }
    return false;
  }

  static Map<String, String>? getUserInfo(String email) {
    return _registeredUsers[email];
  }

  static void setLoggedInEmail(String email) {
    _loggedInEmail = email;
  }
}

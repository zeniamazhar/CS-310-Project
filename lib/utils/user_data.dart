class UserData {
  // email -> { name, username, password, bio }
  static final Map<String, Map<String, String>> _registeredUsers = {};
  static String? _loggedInEmail;

  static bool registerUser({
    required String email,
    required String password,
    required String name,
    required String username,
    String bio = '',
    String notifications = 'false',
  }) {
    if (_registeredUsers.containsKey(email)) {
      return false; // Already exists
    }

    _registeredUsers[email] = {
      'name': name,
      'username': username,
      'password': password,
      'bio': bio,
      'notifications': notifications,
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

  static String? get loggedInEmail => _loggedInEmail;

  static void updateUserInfo(String email, Map<String, String> updates) {
    if (_registeredUsers.containsKey(email)) {
      _registeredUsers[email]!.addAll(updates);
    }
  }

  static bool getNotificationPreference(String email) {
    return _registeredUsers[email]?['notifications'] == 'true';
  }

  static void setNotificationPreference(String email, bool value) {
    if (_registeredUsers.containsKey(email)) {
      _registeredUsers[email]!['notifications'] = value.toString();
    }
  }

}

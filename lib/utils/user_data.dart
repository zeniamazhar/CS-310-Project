// user_data.dart
class UserData {
  // A map of email -> password
  static final Map<String, String> _registeredUsers = {};

  // Register user if email not already used
  // Returns true if registration succeeded, false if email already exists
  static bool registerUser(String email, String password) {
    if (_registeredUsers.containsKey(email)) {
      // Email already taken
      return false;
    }
    _registeredUsers[email] = password;
    return true;
  }

  // Check if email + password match
  static bool authenticate(String email, String password) {
    if (_registeredUsers.containsKey(email)) {
      return _registeredUsers[email] == password;
    }
    return false;
  }
}

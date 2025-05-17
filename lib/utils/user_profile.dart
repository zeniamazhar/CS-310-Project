class UserProfile {
  final String name;
  final String username;
  final String email;
  final String bio;
  final bool notificationsEnabled;

  UserProfile({
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.notificationsEnabled,
  });

  UserProfile copyWith({
    String? name,
    String? username,
    String? email,
    String? bio,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

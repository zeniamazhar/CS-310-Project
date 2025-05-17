import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moveasy/utils/user_profile.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>(
      (ref) => UserProfileNotifier(),
);

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  StreamSubscription<DocumentSnapshot>? _subscription;

  UserProfileNotifier() : super(const AsyncValue.loading()) {
    _listenToUserProfile();
  }

  void _listenToUserProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        state = const AsyncValue.data(null);
        return;
      }

      final data = snapshot.data()!;
      state = AsyncValue.data(
        UserProfile(
          name: data['name'] ?? '',
          username: data['username'] ?? '',
          email: user.email ?? '',
          bio: data['bio'] ?? '',
          notificationsEnabled: data['notificationsEnabled'] ?? false,
        ),
      );
    }, onError: (e, st) {
      state = AsyncValue.error(e, st);
    });
  }

  Future<void> saveChanges({
    required String name,
    required String username,
    required String bio,
    required bool notificationsEnabled,
    String? newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
        'username': username,
        'bio': bio,
        'notificationsEnabled': notificationsEnabled,
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

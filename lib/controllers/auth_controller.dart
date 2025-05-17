
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/auth_provider.dart';
import 'package:flutter/foundation.dart';


final signUpControllerProvider = StateNotifierProvider<SignUpController, AsyncValue<void>>(
      (ref) => SignUpController(ref.watch(authProvider)),
);

class SignUpController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  SignUpController(this._authService) : super(const AsyncData(null));

  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    state = const AsyncLoading();
    final error = await _authService.signUp(
      name: name,
      username: username,
      email: email,
      password: password,
    );
    if (error == null) {
      state = const AsyncData(null);
      onSuccess();
    } else {
      state = AsyncError(error, StackTrace.current);
    }
  }
}

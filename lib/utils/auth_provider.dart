import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authProvider = Provider((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(creds.user!.uid).set({
        'name': name,
        'username': username,
        'email': email,
        'bio': "I love movies!",
        'favorites': [],
        'watchList': [],
        'watchLater': []
      });

      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Unknown error occurred';
    }
  }
}

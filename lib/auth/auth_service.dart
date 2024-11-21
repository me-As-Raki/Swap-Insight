import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign-Up Error: $e');
      rethrow;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;
}

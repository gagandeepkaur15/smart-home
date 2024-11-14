import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<UserModel?> signUpUser(
      String email, String password, String displayName) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(displayName);
        await firebaseUser.reload();
        final updatedUser = _firebaseAuth.currentUser;
        return UserModel(
          id: updatedUser!.uid,
          email: updatedUser.email ?? '',
          displayName: updatedUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Sign Up Failed: ${e.message}");
      throw Exception("Sign Up Failed: ${e.message}");
    } catch (e) {
      debugPrint("An error occurred: $e");
      throw Exception("An error occurred during sign-up.");
    }
    return null;
  }

  Future<UserModel?> signInUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Sign In Failed: ${e.message}");
      throw Exception("Sign In Failed: ${e.message}");
    } catch (e) {
      debugPrint("An error occurred: $e");
      throw Exception("An error occurred during sign-in.");
    }
    return null;
  }

  Future<void> signOutUser() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      debugPrint("Sign Out Failed: $e");
      throw Exception("An error occurred during sign-out.");
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } catch (e) {
      debugPrint("Error fetching current user: $e");
      throw Exception("An error occurred while fetching the current user.");
    }
    return null;
  }
}

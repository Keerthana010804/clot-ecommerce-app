import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web Sign-In
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        final userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // Android / iOS Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.idToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
        await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }



  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut(); // Only for mobile
    }
    await _auth.signOut();
  }
}

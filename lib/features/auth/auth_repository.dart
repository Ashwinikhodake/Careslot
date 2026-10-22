import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _auth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  //Get the currently signed in user.
  Future<void> registerPatient({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
    final user = credential.user;

    if (user == null) {
      throw StateError('Failed to create patient account');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'role': 'patient',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      await user.delete();
      try {} on FirebaseAuthException {
        await _auth.signOut();
      }
    }
  }

  //Sign in any account
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  //Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //fetch the user's firestore profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return null;
    }
    return document.data();
  }

  //Request a password-reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }
}

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DoctorAccountProvisioningService {
  static const String _secondaryAppName = 'doctorProvisioning';
  FirebaseAuth? _secondaryAuth;

  Future<FirebaseAuth> _getSecondaryAuth() async {
    if (_secondaryAuth != null) {
      return _secondaryAuth!;
    }
    FirebaseApp secondaryApp;

    try {
      secondaryApp = Firebase.app(_secondaryAppName);
    } on FirebaseException {
      secondaryApp = await Firebase.initializeApp(
        name: _secondaryAppName,
        options: Firebase.app().options,
      );
    }
    _secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
    return _secondaryAuth!;
  }

  //generateTem password
  String _generateTemporaryPassword() {
    const characters =
        'abcdefghijklmnopqrstuvwxyz'
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        '0123456789'
        '!@#\$%^&';

    final random = Random.secure();
    return List.generate(
      32,
      (_) => characters[random.nextInt(characters.length)],
    ).join();
  }

  //create doctor account without replacing the primary session.
  //keeps the secondary user signed in temporarily for rollback
  Future<String> createDoctorAccount({required String email}) async {
    final secondaryAuth = await _getSecondaryAuth();
    final temporaryPassword = _generateTemporaryPassword();
    try {
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: temporaryPassword,
      );
      final user = credential.user;
      if (user == null) {
        throw StateError('Failed to create doctor account.');
      }
      return user.uid;
    } catch (_) {
      await secondaryAuth.signOut();
      rethrow;
    }
  }

  // delete newly created doc account if profile saving fails
  Future<void> rollbackDoctorAccount(String doctorUid) async {
    final secondaryAuth = await _getSecondaryAuth();
    final user = secondaryAuth.currentUser;
    try {
      if (user == null || user.uid != doctorUid) {
        throw StateError('Cannot identify the doctor account to delete.');
      }
      await user.delete();
      await secondaryAuth.signOut();
    } finally {}
  }

  //sends the password reset email
  Future<void> sendDoctorPasswordResetEmail(String email) async {
    final secondaryAuth = await _getSecondaryAuth();
    await secondaryAuth.sendPasswordResetEmail(
      email: email.trim().toLowerCase(),
    );
  }

  Future<void> finishProvisioning() async {
    final secondaryAuth = await _getSecondaryAuth();
    await secondaryAuth.signOut();
  }
}

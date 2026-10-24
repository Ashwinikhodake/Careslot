import 'package:careslot/features/auth/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final user = authRepository.currentUser;

  if (user == null) {
    return null;
  }
  return authRepository.getUserProfile(user.uid);
});

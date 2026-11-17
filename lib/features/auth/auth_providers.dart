import 'package:careslot/features/auth/auth_repository.dart';
import 'package:careslot/features/auth/doctor_account_provisioning_service.dart';
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
  final user = await ref.watch(authStateProvider.future);

  if (user == null) {
    return null;
  }
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.getUserProfile(user.uid);
});

final doctorAccountProvisioningServiceProvider =
    Provider<DoctorAccountProvisioningService>((ref) {
      return DoctorAccountProvisioningService();
    });

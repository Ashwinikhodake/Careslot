import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:careslot/features/doctors/doctor_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository(firestore: FirebaseFirestore.instance);
});

final availableDoctorsProvider = StreamProvider((ref) {
  return ref.watch(doctorRepositoryProvider).watchAvailableDoctors();
});

final hospitalDoctorsProvider = StreamProvider<List<DoctorModel>>((ref) async* {
  final userProfile = await ref.watch(userProfileProvider.future);

  if (userProfile == null || userProfile['role'] != 'hospital') {
    throw StateError('Hospital profile not found.');
  }
  final hospitalId = userProfile['hospitalId'];

  if (hospitalId is! String || hospitalId.isEmpty) {
    throw StateError('Hospital Id is missing');
  }

  yield* ref.watch(doctorRepositoryProvider).watchHospitalDoctors(hospitalId);
});

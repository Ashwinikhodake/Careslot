import 'package:careslot/features/doctors/doctor_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository(firestore: FirebaseFirestore.instance);
});

final availableDoctorsProvider = StreamProvider((ref) {
  return ref.watch(doctorRepositoryProvider).watchAvailableDoctors();
});

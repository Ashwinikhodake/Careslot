import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:careslot/features/doctors/doctor_registration_service.dart';
import 'package:careslot/features/doctors/doctor_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository(firestore: FirebaseFirestore.instance);
});

final availableDoctorsProvider = StreamProvider<List<DoctorModel>>((ref) {
  return ref.watch(doctorRepositoryProvider).watchAvailableDoctors();
});

final hospitalDoctorsProvider = StreamProvider<List<DoctorModel>>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  final userProfileFuture = ref.watch(userProfileProvider.future);

  return _watchHospitalDoctors(repository, userProfileFuture);
});

Stream<List<DoctorModel>> _watchHospitalDoctors(
  DoctorRepository repository,
  Future<Map<String, dynamic>?> userProfileFuture,
) async* {
  final userProfile = await userProfileFuture;
  if (userProfile == null || userProfile['role'] != 'hospital') {
    throw StateError('Hospital profile not found.');
  }
  final hospitalId = userProfile['hospitalId'];

  if (hospitalId is! String || hospitalId.isEmpty) {
    throw StateError('Hospital Id is missing');
  }

  yield* repository.watchHospitalDoctors(hospitalId);
}

final doctorRegistrationServiceProvider = Provider<DoctorRegistrationService>((
  ref,
) {
  return DoctorRegistrationService(
    firestore: FirebaseFirestore.instance,
    provisioningService: ref.watch(doctorAccountProvisioningServiceProvider),
  );
});

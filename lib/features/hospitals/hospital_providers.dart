import 'package:careslot/features/auth/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hospital_model.dart';
import 'hospital_repository.dart';

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  return HospitalRepository();
});

final hospitalProfileProvider = FutureProvider<HospitalModel?>((ref) async {
  final userProfile = await ref.watch(userProfileProvider.future);

  if (userProfile == null || userProfile['role'] != 'hospital') {
    return null;
  }

  final hospitalId = userProfile['hospitalId'];

  if (hospitalId is! String || hospitalId.isEmpty) {
    return null;
  }

  final repository = ref.watch(hospitalRepositoryProvider);

  return repository.getHospitalById(hospitalId);
});

import 'package:careslot/features/hospitals/hospital_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  return HospitalRepository();  
});

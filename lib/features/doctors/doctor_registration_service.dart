import 'package:careslot/features/auth/doctor_account_provisioning_service.dart';
import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorRegistrationService {
  DoctorRegistrationService({
    required FirebaseFirestore firestore,
    required DoctorAccountProvisioningService provisioningService,
  }) : _firestore = firestore,
       _provisioningService = provisioningService;

  final FirebaseFirestore _firestore;
  final DoctorAccountProvisioningService _provisioningService;

  Future<DoctorModel> registerDoctor({
    required String name,
    required String email,
    required String specialty,
    required String hospitalId,
    String? profileImageUrl,
    double? consultationFee,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    //create firebase auth account
    final doctorUid = await _provisioningService.createDoctorAccount(
      email: normalizedEmail,
    );

    final doctor = DoctorModel(
      id: doctorUid,
      uid: doctorUid,
      name: name.trim(),
      email: normalizedEmail,
      specialty: specialty.trim(),
      hospitalId: hospitalId,
      profileImageUrl: profileImageUrl,
      consultationFee: consultationFee,
    );

    //save both firestore documents automatically
    try {
      final batch = _firestore.batch();

      batch.set(_firestore.collection('users').doc(doctorUid), {
        'uid': doctorUid,
        'name': doctor.name,
        'email': doctor.email,
        'role': 'doctor',
        'hospitalId': hospitalId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.set(_firestore.collection('doctors').doc(doctorUid), {
        ...doctor.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } catch (error, stackTrace) {
      //role back the auth account if firestore saving fails.
      try {
        await _provisioningService.rollbackDoctorAccount(doctorUid);
      } catch (rollbackError) {
        throw StateError(
          'Doctor profile creation failed and account cleanup also failed.'
          'Doctor UId: $doctorUid.'
          'Original error: $error.'
          'Cleanup error: $rollbackError',
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    }

    //send password reset email after successful profile creation.
    try {
      await _provisioningService.sendDoctorPasswordResetEmail(normalizedEmail);
    } finally {
      await _provisioningService.finishProvisioning();
    }
    return doctor;
  }
}

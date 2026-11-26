import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorRepository {
  DoctorRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _doctors =>
      _firestore.collection('doctors');

  Stream<List<DoctorModel>> watchAvailableDoctors() {
    return _doctors.where('isAvailable', isEqualTo: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((document) {
        return DoctorModel.fromMap(document.id, document.data());
      }).toList();
    });
  }

  Stream<List<DoctorModel>> watchHospitalDoctors(String hospitalId) {
    return _doctors.where('hospitalId', isEqualTo: hospitalId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((document) {
        return DoctorModel.fromMap(document.id, document.data());
      }).toList();
    });
  }

  Future<DoctorModel?> getDoctorById(String doctorId) async {
    final document = await _doctors.doc(doctorId).get();

    if (!document.exists) {
      return null;
    }

    return DoctorModel.fromMap(document.id, document.data()!);
  }

  Future<void> createDoctor(DoctorModel doctor) async {
    await _doctors.doc(doctor.uid).set({
      ...doctor.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDoctorAvailability({
    required String doctorId,
    required bool isAvailable,
  }) async {
    await _doctors.doc(doctorId).update({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDoctorProfile({
    required String doctorId,
    required String name,
    required String specialty,
    required String? profileImageUrl,
    required double? consultationFee,
  }) async {
    await _doctors.doc(doctorId).update({
      'name': name.trim(),
      'specialty': specialty.trim(),
      'profileImageUrl': profileImageUrl,
      'consultationFee': consultationFee,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

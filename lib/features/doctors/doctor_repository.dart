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

  Future<DoctorModel?> getDoctorById(String doctorId) async {
    final document = await _doctors.doc(doctorId).get();

    if (!document.exists) {
      return null;
    }

    return DoctorModel.fromMap(document.id, document.data()!);
  }
}

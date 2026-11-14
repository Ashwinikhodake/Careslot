import 'package:careslot/features/appointments/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentRepository {
  AppointmentRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  Future<String> createAppointment(AppointmentModel appointment) async {
    final document = _appointments.doc();

    await document.set(appointment.toMap());
    return document.id;
  }

  Stream<List<AppointmentModel>> watchPatientAppointments(String patientId) {
    return _appointments
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((document) {
            return AppointmentModel.fromMap(document.id, document.data());
          }).toList();
        });
  }
}

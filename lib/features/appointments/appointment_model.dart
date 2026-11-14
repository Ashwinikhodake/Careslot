import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.hospitalId,
    required this.appointmentDateTime,
    required this.status,
    this.createdAt,
  });
  final String id;
  final String patientId;
  final String doctorId;
  final String hospitalId;
  final DateTime appointmentDateTime;
  final String status;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'hospitalId': hospitalId,
      'appointmentDateTime': Timestamp.fromDate(appointmentDateTime),
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AppointmentModel.fromMap(String id, Map<String, dynamic> map) {
    final appointmentTime = map['appointmentDateTime'];
    final creationTime = map['createdAt'];

    if (appointmentTime is! Timestamp) {
      throw const FormatException('Invalid appointment date and time.');
    }
    return AppointmentModel(
      id: id,
      patientId: map['patientId'] as String,
      doctorId: map['doctorId'] as String,
      hospitalId: map['hospitalId'] as String,
      appointmentDateTime: appointmentTime.toDate(),
      status: map['status'] as String,
      createdAt: creationTime is Timestamp ? creationTime.toDate() : null,
    );
  }
}

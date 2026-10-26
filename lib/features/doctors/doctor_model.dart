class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospitalId,
    this.profileImageUrl,
    this.consultationFee,
    this.isAvailable = true,
  });
  final String id;
  final String name;
  final String specialty;
  final String hospitalId;
  final String? profileImageUrl;
  final double? consultationFee;
  final bool isAvailable;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'hospitalId': hospitalId,
      'profileImageUrl': profileImageUrl,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
    };
  }

  factory DoctorModel.fromMap(String id, Map<String, dynamic> map) {
    final fee = map['consultationFee'];

    return DoctorModel(
      id: id,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      hospitalId: map['hospitalId'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      consultationFee: fee is num ? fee.toDouble() : null,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }
}

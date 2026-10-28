class HospitalModel {
  const HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contactNumber,
    required this.email,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String address;
  final String contactNumber;
  final String email;
  final bool isActive;

  factory HospitalModel.fromMap(String id, Map<String, dynamic> map) {
    return HospitalModel(
      id: id,
      name: map['name'] as String,
      address: map['address'] as String,
      contactNumber: map['contactNumber'] as String,
      email: map['email'] as String,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'isActive': isActive,
    };
  }
}

import 'package:careslot/features/hospitals/hospital_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalRepository {
  HospitalRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  
  CollectionReference<Map<String, dynamic>> get _hospitals =>
      _firestore.collection('hospitals');

  Future<HospitalModel?> getHospitalById(String hospitalId) async {
    final document = await _hospitals.doc(hospitalId).get();

    if (!document.exists || document.data() == null) {
      return null;
    }
    return HospitalModel.fromMap(document.id, document.data()!);
  }

  Stream<List<HospitalModel>> watchActiveHospitals() {
    return _hospitals.where('isActive', isEqualTo: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((document) {
        return HospitalModel.fromMap(document.id, document.data());
      }).toList();
    });
  }
}

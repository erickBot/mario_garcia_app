import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/support.dart';

class SupportService {
  CollectionReference? _ref;
  Support? support;

  SupportService() {
    _ref = FirebaseFirestore.instance.collection('Support');
  }

  Future<Support?> getSupport() async {
    DocumentSnapshot document = await _ref!.doc('1').get();

    if (document.exists) {
      support = Support.fromJson(document.data() as Map<String, dynamic>);
      return support;
    }
    return null;
  }
}

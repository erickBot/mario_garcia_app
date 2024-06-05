import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/business.dart';

class PlantasService {
  CollectionReference? _ref;
  Business? busness;

  PlantasService() {
    _ref = FirebaseFirestore.instance.collection('Plantas');
  }

  Future<List<Business>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<Business> list = [];

    for (var data in allData) {
      list.add(Business.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }
}

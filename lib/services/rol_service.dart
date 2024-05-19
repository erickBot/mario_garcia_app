import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/rol.dart';

class RolService {
  CollectionReference? _ref;
  Rol? rol;

  RolService() {
    _ref = FirebaseFirestore.instance.collection('Roles');
  }

  Future<Rol?> getByUserId(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      rol = Rol.fromJson(document.data() as Map<String, dynamic>);
      return rol;
    }
    return null;
  }

  Future<Rol?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      rol = Rol.fromJson(document.data() as Map<String, dynamic>);
      return rol;
    }
    return null;
  }

  Future<List<Rol>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<Rol> list = [];

    for (var data in allData) {
      list.add(Rol.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }
}

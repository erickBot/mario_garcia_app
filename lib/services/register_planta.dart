import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';

class RegisterPlantaService {
  CollectionReference? _ref;
  RegisterPlanta? register;

  RegisterPlantaService() {
    _ref = FirebaseFirestore.instance.collection('RegisterPlanta');
  }

  Future<void> create(RegisterPlanta register) async {
    try {
      String id = _ref!.doc().id;
      register.id = id;
      return _ref!.doc(register.id).set(register.toJson());
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<RegisterPlanta?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      register =
          RegisterPlanta.fromJson(document.data() as Map<String, dynamic>);
      return register;
    }
    return null;
  }

  Future<void> delete(String id) async {
    await _ref!.doc(id).delete();
  }

  //actualizar informacion en firebase
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref!.doc(id).update(data);
  }

  //obtener datos del client en tiempo real
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<List<RegisterPlanta>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByIdOperator(String id) async {
    QuerySnapshot querySnapshot =
        await _ref!.where('id_operator', isEqualTo: id).get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByIdOperatorAndMonth(
      String id, String month) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('id_operator', isEqualTo: id)
        .where('month', isEqualTo: month)
        .orderBy('timestamp', descending: true)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByMonth(String month) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('month', isEqualTo: month)
        .orderBy('timestamp', descending: true)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByPeriodo(
      int timestamp1, int timestamp2) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('timestamp', isLessThanOrEqualTo: timestamp1)
        .where('timestamp', isGreaterThanOrEqualTo: timestamp2)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByYear(String year) async {
    QuerySnapshot querySnapshot =
        await _ref!.where('year', isEqualTo: year).get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<RegisterPlanta>> getByIdOperatorAndStatus(
      String id, String status) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('id_operator', isEqualTo: id)
        .where('status', isEqualTo: status)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<RegisterPlanta> list = [];

    for (var data in allData) {
      list.add(RegisterPlanta.fromJson(data as Map<String, dynamic>));
    }
    return list;
  }
}

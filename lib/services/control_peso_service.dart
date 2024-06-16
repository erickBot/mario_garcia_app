import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';

class ControlPesoService {
  CollectionReference? _ref;
  ControlPeso? control;

  ControlPesoService() {
    _ref = FirebaseFirestore.instance.collection('ControlPesos');
  }

  Future<void> create(ControlPeso control) async {
    try {
      String id = _ref!.doc().id;
      control.id = id;
      return _ref!.doc(control.id).set(control.toJson());
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<ControlPeso?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      control = ControlPeso.fromJson(document.data() as Map<String, dynamic>);
      return control;
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

  Future<List<ControlPeso>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByIdOperator(String id) async {
    QuerySnapshot querySnapshot =
        await _ref!.where('id_operator', isEqualTo: id).get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByIdOperatorAndMonth(
      String id, String month) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('id_operator', isEqualTo: id)
        .where('month', isEqualTo: month)
        .orderBy('timestamp', descending: true)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByMonth(String month) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('month', isEqualTo: month)
        .orderBy('timestamp', descending: true)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByIdOperatorAndStatus(
      String id, String status) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('id_operator', isEqualTo: id)
        .where('status', isEqualTo: status)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByPeriodo(int timestamp1, int timestamp2) async {
    QuerySnapshot querySnapshot = await _ref!
        .where('timestamp', isLessThanOrEqualTo: timestamp1)
        .where('timestamp', isGreaterThanOrEqualTo: timestamp2)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }

  Future<List<ControlPeso>> getByYear(String year) async {
    QuerySnapshot querySnapshot =
        await _ref!.where('year', isEqualTo: year).get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<ControlPeso> list = [];

    for (var data in allData) {
      list.add(ControlPeso.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }
}

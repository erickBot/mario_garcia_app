import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';

class LavadorService {
  CollectionReference? _ref;
  Lavador? lavador;

  LavadorService() {
    _ref = FirebaseFirestore.instance.collection('Lavadores');
  }

  Future<void> create(Lavador lavador) async {
    try {
      String id = _ref!.doc().id;
      lavador.id = id;
      return _ref!.doc(lavador.id).set(lavador.toJson());
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Lavador?> getById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      lavador = Lavador.fromJson(document.data() as Map<String, dynamic>);
      return lavador;
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

  Future<List<Lavador>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<Lavador> list = [];

    for (var data in allData) {
      list.add(Lavador.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';

class UserService {
  CollectionReference? _ref;
  UserModel? user;

  UserService() {
    _ref = FirebaseFirestore.instance.collection('Users');
  }

  Future<void> create(UserModel user) async {
    try {
      return _ref!.doc(user.id).set(user.toJson());
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<UserModel?> getByUserId(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      user = UserModel.fromJson(document.data() as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  //actualizar informacion en firebase
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref!.doc(id).update(data);
  }

  //obtener datos del client en tiempo real
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<List<UserModel>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((doc) => doc.data());

    List<UserModel> list = [];

    for (var data in allData) {
      list.add(UserModel.fromJson(data as Map<String, dynamic>));
    }

    return list;
  }
}

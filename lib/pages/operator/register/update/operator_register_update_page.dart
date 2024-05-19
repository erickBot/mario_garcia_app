import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OperatorRegisterUpdatePage extends StatefulWidget {
  final ControlPeso control;
  const OperatorRegisterUpdatePage({super.key, required this.control});

  @override
  State<OperatorRegisterUpdatePage> createState() =>
      _OperatorRegisterUpdatePageState();
}

class _OperatorRegisterUpdatePageState
    extends State<OperatorRegisterUpdatePage> {
  UserModel? user;

  //
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar registro'),
      ),
    );
  }
}

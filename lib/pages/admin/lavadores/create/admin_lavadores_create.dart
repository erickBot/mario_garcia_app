import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mario_garcia_app/models/rol.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLavadoresCreate extends StatefulWidget {
  const AdminLavadoresCreate({super.key});

  @override
  State<AdminLavadoresCreate> createState() => _AdminLavadoresCreateState();
}

class _AdminLavadoresCreateState extends State<AdminLavadoresCreate> {
  final LavadorService _lavadorService = LavadorService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  void registro() async {
    String name = _nameController.text;
    String lastname = _lastnameController.text;

    if (name.isEmpty && lastname.isEmpty) {
      //print('el usuario debe ingresar todos los campos');
      Fluttertoast.showToast(msg: 'Se debe ingresar todos los campos');
      return;
    }

    try {
      // _progressDialog?.show(
      //     max: 100,
      //     msg: 'Espere un momento',
      //     progressValueColor: active,
      //     progressBgColor: light);
      //

      String createdAt =
          DateFormat.yMd().add_jm().format(DateTime.now()).toString();

      //crea objeto client
      Lavador lavador = Lavador(
        name: name,
        lastname: lastname,
        createdAt: createdAt,
      );

      await _lavadorService.create(lavador);

      Fluttertoast.showToast(msg: 'Lavador fue creado con éxito');
      Navigator.pop(context, true);
    } catch (error) {
      //_progressDialog?.close();
      Fluttertoast.showToast(msg: 'Ocurrio un error!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear lavador'),
      ),
      body: ListView(
        children: [
          _inputName(),
          _inputLastName(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _inputName() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Nombres',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          //suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _inputLastName() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Apellidos',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          // suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _button() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: registro,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
        ),
        child: const CustomText(
            text: 'CREAR LAVADOR',
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}

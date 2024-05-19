import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mario_garcia_app/models/rol.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/services/authentication_service.dart';
import 'package:flutter_mario_garcia_app/services/rol_service.dart';
import 'package:flutter_mario_garcia_app/services/user_service.dart';
import 'package:flutter_mario_garcia_app/utils/shared_preferences.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminAccountsCreate extends StatefulWidget {
  const AdminAccountsCreate({super.key});

  @override
  State<AdminAccountsCreate> createState() => _AdminAccountsCreateState();
}

class _AdminAccountsCreateState extends State<AdminAccountsCreate> {
  final RolService _rolService = RolService();
  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  final UserService _userService = UserService();
  final SharedPref _prefs = SharedPref();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Rol> roles = [];
  Rol? rol;
  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRoles();
  }

  void refresh() {
    setState(() {});
  }

  void getRoles() async {
    roles = await _rolService.getAll();
    refresh();
  }

  String? validateEmail(String value) {
    value = value.trim();
    if (_emailController.text.isNotEmpty) {
      if (value.isEmpty) {
        isError = true;
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        isError = true;
        return 'Ingrese un email correcto';
      }
    }
    isError = false;
    return null;
  }

  String? validatePassword(String value) {
    value = value.trim();
    if (_passwordController.text.isNotEmpty) {
      if (value.isEmpty) {
        isError = true;
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        isError = true;
        return 'La contraseña debe tener mínimo 6 caracteres';
      }
    }
    isError = false;
    return null;
  }

  void registro() async {
    String name = _nameController.text;
    String lastname = _lastnameController.text;
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty && lastname.isEmpty && email.isEmpty && password.isEmpty) {
      //print('el usuario debe ingresar todos los campos');
      Fluttertoast.showToast(msg: 'Se debe ingresar todos los campos');
      return;
    }

    if (rol == null) {
      Fluttertoast.showToast(msg: 'Debe seleccionar un rol');
      return;
    }

    if (password.length < 6) {
      //print('password debe tener 6 caracteres');
      Fluttertoast.showToast(
          msg: 'La contrasena debe tener minimo 6 caracteres');
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
      bool isCreate = await _authFirebaseService.register(email, password);

      if (isCreate) {
        //crea objeto client
        UserModel client = UserModel(
          id: _authFirebaseService.getUser()!.uid,
          name: name,
          lastname: lastname,
          email: email,
          idRol: rol!.id,
          rolName: rol!.name,
          available: true,
          createdAt: createdAt,
        );

        await _userService.create(client);

        Fluttertoast.showToast(msg: 'Usuario fue creado con éxito');
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: 'Error al crear cuenta');
      }
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
        title: const Text('Crear cuenta'),
      ),
      body: ListView(
        children: [
          _dropDown(),
          _inputName(),
          _inputLastName(),
          _inputEmail(),
          _inputPassword(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _dropDown() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black54),
      ),
      child: DropdownButton<Rol>(
        value: rol,
        hint: const Text('Selecciona un rol'),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 14,
        style: const TextStyle(color: Colors.black),
        underline: Container(),
        onChanged: (Rol? value) {
          // This is called when the user selects an item.
          setState(() {
            rol = value!;
          });
        },
        items: roles.map<DropdownMenuItem<Rol>>((Rol value) {
          return DropdownMenuItem<Rol>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      ),
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

  Widget _inputEmail() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            isEditingEmail = true;
          });
        },
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
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
          errorText:
              isEditingEmail ? validateEmail(_emailController.text) : null,
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        onChanged: (value) {
          setState(() {
            isEditingPassword = true;
          });
        },
        decoration: InputDecoration(
          hintText: 'Contraseña',
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
          //suffixIcon: const Icon(Icons.block_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
          errorText: isEditingPassword
              ? validatePassword(_passwordController.text)
              : null,
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
            text: 'CREAR CUENTA',
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/user_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});
  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final UserService _userService = UserService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    _nameController.text = user?.name ?? '';
    _lastnameController.text = user?.lastname ?? '';
    _phoneController.text = user?.phone ?? '';
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  void update() async {
    try {
      String name = _nameController.text;
      String lastname = _lastnameController.text;
      String phone = _phoneController.text;

      Map<String, dynamic> data = {
        'name': name,
        'lastname': lastname,
        'phone': phone,
      };

      await _userService.update(data, user!.id!);

      user = await _userService.getByUserId(user!.id!);

      Provider.of<UserProvider>(context, listen: false).setUser(user!);

      Fluttertoast.showToast(msg: 'Se actualizaron los datos');

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrio un error!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _imageUser(),
          _userName(),
          _userLastName(),
          _telefono(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _imageUser() {
    final size = MediaQuery.of(context).size.height;
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                image: AssetImage('assets/img/profile.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 1),
      ],
    );
  }

  Widget _userName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Nombres',
          labelStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _userLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: _lastnameController,
        decoration: InputDecoration(
          labelText: 'Apellidos',
          labelStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          prefixIcon: const Icon(Icons.person, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _telefono() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Número celular',
          labelStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          prefixIcon:
              const Icon(Icons.phone_android_outlined, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _button() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: update,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
        ),
        child: const CustomText(
            text: 'ACTUALIZAR',
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}

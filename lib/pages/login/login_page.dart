import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/rol.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/authentication_service.dart';
import 'package:flutter_mario_garcia_app/services/rol_service.dart';
import 'package:flutter_mario_garcia_app/services/user_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  final RolService _rolService = RolService();
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isError = false;
  bool isLoading = true;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    checkIdUserIsAuth();
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  void checkIdUserIsAuth() async {
    bool isSigned = _authFirebaseService.isSignedIn();

    if (isSigned) {
      user =
          await _userService.getByUserId(_authFirebaseService.getUser()!.uid);

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user!);
        Rol? rol = await _rolService.getById(user!.idRol!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, rol!.route, (route) => false);
        });
      } else {
        Fluttertoast.showToast(msg: 'Usuario no registrado!');
        return;
      }
    }
  }

  void login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim(); //trim para
      // _progressDialog?.show(
      //     max: 100,
      //     msg: 'Espere un momento',
      //     progressValueColor: active,
      //     progressBgColor: light);

      bool isLogin = await _authFirebaseService.login(email, password);

      if (isLogin) {
        user =
            await _userService.getByUserId(_authFirebaseService.getUser()!.uid);

        if (user != null) {
          Provider.of<UserProvider>(context, listen: false).setUser(user!);
          Rol? rol = await _rolService.getById(user!.idRol!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, rol!.route, (route) => false);
          });
        } else {
          Fluttertoast.showToast(msg: 'Usuario no registrado!');
          return;
        }
      } else {
        //print('Usuario no registrado');
        //_progressDialog?.close();
        Fluttertoast.showToast(msg: 'Usuario no registrado');
        return;
      }
    } catch (error) {
      //print('Error: $error');
      //_progressDialog?.close();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        //padding: const EdgeInsets.symmetric(horizontal: 510),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Ingresar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                  text: 'Correo electrónico',
                  size: 16,
                  weight: FontWeight.w500),
            ),
            _inputEmail(),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                  text: 'Contraseña', size: 16, weight: FontWeight.w500),
            ),
            _inputPassword(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _button(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          suffixIcon: const Icon(Icons.block_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
          errorText: isEditingPassword
              ? validatePassword(_passwordController.text)
              : null,
        ),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      onPressed: login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.all(20),
      ),
      child: const CustomText(
          text: 'INGRESAR',
          size: 16,
          weight: FontWeight.w500,
          color: Colors.white),
    );
  }
}

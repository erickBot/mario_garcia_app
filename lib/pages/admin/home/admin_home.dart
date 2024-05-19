import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/authentication_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  //
  @override
  void initState() {
    super.initState();
  }

  //
  void openDrawer() {
    key.currentState!.openDrawer();
  }

  //cerrar sesion
  void signOut() async {
    await _authFirebaseService.signOut();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      drawer: _drawer(size),
      appBar: AppBar(
        title: const Text('Administrador'),
        leading: IconButton(
          onPressed: openDrawer,
          icon: const Icon(Icons.menu),
        ),
      ),
    );
  }

  Widget _drawer(Size size) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage('assets/img/profile.jpg'),
                      backgroundColor: Colors.white,
                      radius: size.height > 700 ? 35 : 25,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: value.currentUser.name,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    CustomText(
                      text: value.currentUser.email,
                      size: 14,
                    ),
                  ],
                ),
                // decoration: BoxDecoration(
                //   color: Colors.amber,
                // ),
              ),
              _listTile('Mi cuenta', 'update', Icons.person_outline),
              _listTile('Cuentas', 'admin/accounts/list', Icons.people_outline),
              _listTile(
                  'Lavadores', 'admin/lavadores/list', Icons.list_alt_outlined),
              _listTile('Compartir App', 'client/share', Icons.share),
              _listTile('Ayuda', 'client/help', Icons.help),
              ListTile(
                title: const CustomText(
                  text: 'Términos y Condiciones',
                  size: 14,
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://taxmoto-server-politicas-terminos.fly.dev/terminos.html'));
                },
                leading: const Icon(Icons.info_outline, size: 20),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
              ListTile(
                title: const CustomText(
                  text: 'Política de Privacidad',
                  size: 14,
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://taxmoto-server-politicas-terminos.fly.dev/politica.html'));
                },
                leading: const Icon(Icons.info_outline, size: 20),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
              ListTile(
                title: const CustomText(
                  text: 'Cerrar sesión',
                  size: 14,
                ),
                onTap: signOut,
                leading:
                    const Icon(Icons.power_settings_new_outlined, size: 20),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listTile(String text, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 20),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
      title: CustomText(
        text: text,
        size: 14,
      ),
      onTap: () {
        Navigator.popAndPushNamed(context, route);
      },
    );
  }
}

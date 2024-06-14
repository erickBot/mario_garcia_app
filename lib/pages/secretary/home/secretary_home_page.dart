import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/authentication_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SecretaryHomePage extends StatefulWidget {
  const SecretaryHomePage({super.key});

  @override
  State<SecretaryHomePage> createState() => _SecretaryHomePageState();
}

class _SecretaryHomePageState extends State<SecretaryHomePage> {
  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> list = [
    {
      "name": "Registros muelle",
      "icon": FontAwesomeIcons.productHunt,
      "route": "secretary/muelle/list"
    },
    {
      "name": "Registros planta",
      "icon": FontAwesomeIcons.industry,
      "route": "secretary/planta/list"
    },
  ];

  @override
  void initState() {
    super.initState();
  }

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
        title: const Text('Secretaria'),
        leading: IconButton(
          onPressed: openDrawer,
          icon: const Icon(Icons.menu),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          scrollDirection: Axis.vertical,
          children: list
              .map((Map<String, dynamic> model) => _cardOption(model))
              .toList(),
        ),
      ),
    );
  }

  Widget _cardOption(Map<String, dynamic> model) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, model['route']);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: .5, color: Colors.black54),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(model['icon'], color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            CustomText(text: model['name'], weight: FontWeight.w500, size: 16),
          ],
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
              _listTile('Compartir App', 'client/share', Icons.share),
              _listTile('Ayuda', 'client/help', Icons.help),
              ListTile(
                title: const CustomText(
                  text: 'Términos y Condiciones',
                  size: 14,
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://mario-garcia-server-politicas-terminos.fly.dev/terminos.html'));
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
                      'https://mario-garcia-server-politicas-terminos.fly.dev/politica.html'));
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

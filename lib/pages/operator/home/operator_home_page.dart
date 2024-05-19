import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/operator/register/update/operator_register_update_page.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/authentication_service.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OperatorHomePage extends StatefulWidget {
  const OperatorHomePage({super.key});

  @override
  State<OperatorHomePage> createState() => _OperatorHomePageState();
}

class _OperatorHomePageState extends State<OperatorHomePage> {
  final AuthFirebaseService _authFirebaseService = AuthFirebaseService();
  final ControlPesoService _controlPesoService = ControlPesoService();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  UserModel? user;
  bool isHover = false;
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
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

  Future<List<ControlPeso>> getRegisters() async {
    return await _controlPesoService.getByIdOperatorAndStatus(
        user!.id!, 'INICIADO');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: _drawer(size),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            title: const Text('Operador'),
            flexibleSpace: Column(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'operator/register/create');
                  },
                  onHover: (value) {
                    isHover = !isHover;
                    print(isHover);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText(text: 'Nuevo registro', color: Colors.white),
                        Icon(Icons.add, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: getRegisters(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _cardControlPeso(snapshot.data![index]),
                );
              } else {
                return Container();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _cardControlPeso(ControlPeso control) {
    return GestureDetector(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                OperatorRegisterUpdatePage(control: control),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.black54),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(text: 'Registro'),
            CustomText(
                text: '${control.date} ${control.hourInit}',
                size: 14,
                color: Colors.black54),
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

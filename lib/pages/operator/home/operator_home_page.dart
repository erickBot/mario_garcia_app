import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/operator/register/create/operator_register_create_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/register/detail/operator_register_detail_page.dart';
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
  String? month;
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    month = DateTime.now().month.toString();
    refresh();
  }

  void refresh() {
    setState(() {});
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
    return await _controlPesoService.getByIdOperatorAndMonth(user!.id!, month!);
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
                  onTap: () async {
                    final res = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (BuildContext context) =>
                            const OperatorRegisterCreatePage(),
                      ),
                    );

                    if (res != null) {
                      if (res) {
                        refresh();
                      }
                    }
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
      onTap: () async {
        if (control.status == 'INICIADO') {
          final res = await Navigator.push<bool>(
            context,
            MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  OperatorRegisterUpdatePage(control: control),
            ),
          );

          if (res != null) {
            if (res) {
              refresh();
            }
          }
        } else {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  OperatorRegisterDetailPage(control: control),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.black54),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: control.embarcacion),
                CustomText(
                  text: '${control.date} ${control.hourInit}',
                  size: 14,
                  weight: FontWeight.w300,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: control.status!,
                  size: 12,
                  color: control.status == 'FINALIZADO'
                      ? Colors.red
                      : Colors.green,
                  weight: FontWeight.w300,
                ),
                CustomText(
                  text: '${control.totalWeight ?? 0} kg.',
                  size: 14,
                  weight: FontWeight.w300,
                ),
              ],
            ),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/pages/admin/accounts/create/admin_accounts_create.dart';
import 'package:flutter_mario_garcia_app/pages/admin/accounts/list/admin_accounts_list.dart';
import 'package:flutter_mario_garcia_app/pages/admin/home/admin_home.dart';
import 'package:flutter_mario_garcia_app/pages/admin/lavadores/create/admin_lavadores_create.dart';
import 'package:flutter_mario_garcia_app/pages/admin/lavadores/list/admin_lavadores_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/admin/muelle/list/admin_muelle_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/assistent/home/assistent_home_page.dart';
import 'package:flutter_mario_garcia_app/pages/help_share_app/help_page.dart';
import 'package:flutter_mario_garcia_app/pages/help_share_app/share_app_page.dart';
import 'package:flutter_mario_garcia_app/pages/login/login_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/home/operator_home_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/muelle/create/operator_muelle_create_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/muelle/list/operator_muelle_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/planta/create/operator_planta_create_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/planta/list/operator_planta_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/secretary/home/secretary_home_page.dart';
import 'package:flutter_mario_garcia_app/pages/update/update_page.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mario Garcia',
        initialRoute: 'login',
        routes: {
          'login': (_) => const LoginPage(),
          'update': (_) => const UpdatePage(),
          'admin/home': (_) => const AdminHomePage(),
          'admin/accounts/list': (_) => const AdminAccountsList(),
          'admin/accounts/create': (_) => const AdminAccountsCreate(),
          'admin/lavadores/list': (_) => const AdminLavadoresListPage(),
          'admin/lavadores/create': (_) => const AdminLavadoresCreate(),
          'admin/muelle/list': (_) => const AdminMuelleListPage(),
          'operator/home': (_) => const OperatorHomePage(),
          'secretary/home': (_) => const SecretaryHomePage(),
          'assistent/home': (_) => const AssistentHomePage(),
          'client/share': (BuildContext context) => const ShareAppPage(),
          'client/help': (BuildContext context) => const HelpPage(),
          'operator/muelle/list': (_) => const OperatorMuelleListPage(),
          'operator/planta/list': (_) => const OperatorPlantaListPage(),
        },
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 16),
          elevation: 0,
        )),
      ),
    );
  }
}

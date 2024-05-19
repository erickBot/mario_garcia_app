import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/pages/admin/accounts/create/admin_accounts_create.dart';
import 'package:flutter_mario_garcia_app/pages/admin/accounts/list/admin_accounts_list.dart';
import 'package:flutter_mario_garcia_app/pages/admin/home/admin_home.dart';
import 'package:flutter_mario_garcia_app/pages/admin/lavadores/create/admin_lavadores_create.dart';
import 'package:flutter_mario_garcia_app/pages/admin/lavadores/list/admin_lavadores_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/assistent/home/assistent_home_page.dart';
import 'package:flutter_mario_garcia_app/pages/login/login_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/home/operator_home_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/register/create/operator_register_create_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/register/update/operator_register_update_page.dart';
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
          'login': (_) => LoginPage(),
          'update': (_) => UpdatePage(),
          'admin/home': (_) => AdminHomePage(),
          'admin/accounts/list': (_) => AdminAccountsList(),
          'admin/accounts/create': (_) => AdminAccountsCreate(),
          'admin/lavadores/list': (_) => AdminLavadoresListPage(),
          'admin/lavadores/create': (_) => AdminLavadoresCreate(),
          'operator/home': (_) => OperatorHomePage(),
          'operator/register/create': (_) => OperatorRegisterCreatePage(),
          'secretary/home': (_) => SecretaryHomePage(),
          'assistent/home': (_) => AssistentHomePage(),
        },
        theme: ThemeData(appBarTheme: AppBarTheme(elevation: 0)),
      ),
    );
  }
}

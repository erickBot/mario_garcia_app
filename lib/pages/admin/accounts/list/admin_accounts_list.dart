import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/services/user_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';

class AdminAccountsList extends StatefulWidget {
  const AdminAccountsList({super.key});

  @override
  State<AdminAccountsList> createState() => _AdminAccountsListState();
}

class _AdminAccountsListState extends State<AdminAccountsList> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  Future<List<UserModel>> getUsers() async {
    return await _userService.getAll();
  }

  void refresh() {
    setState(() {});
  }

  void updateUser(UserModel user) async {
    Map<String, dynamic> data = {
      'available': user.available,
    };
    await _userService.update(data, user.id!);

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cuentas'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'admin/accounts/create');
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _cardUser(snapshot.data![index]),
                );
              } else {
                return Container();
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _cardUser(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: '${user.name} ${user.lastname}',
              size: 14,
              weight: FontWeight.w400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: user.rolName!, size: 14, weight: FontWeight.w300),
              Switch(
                  value: user.available,
                  onChanged: (value) {
                    user.available = value;
                    updateUser(user);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

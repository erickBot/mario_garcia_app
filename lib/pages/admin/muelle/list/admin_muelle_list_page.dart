import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/admin/muelle/detail/admin_muelle_detail_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/muelle/detail/operator_muelle_detail_page.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';

import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class AdminMuelleListPage extends StatefulWidget {
  const AdminMuelleListPage({super.key});

  @override
  State<AdminMuelleListPage> createState() => _AdminMuelleListPageState();
}

class _AdminMuelleListPageState extends State<AdminMuelleListPage> {
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

  Future<List<ControlPeso>> getRegisters() async {
    return await _controlPesoService.getByMonth(month!);
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registros muelle'),
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
                AdminMuelleDetailPage(control: control),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                SizedBox(
                  width: 190,
                  child: Text(control.embarcacion,
                      overflow: TextOverflow.ellipsis),
                ),
                CustomText(
                  text: '${control.date} ${control.hourInit}',
                  size: 12,
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
}

import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/operator/muelle/detail/operator_muelle_detail_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/muelle/update/operator_muelle_update_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/planta/create/operator_planta_create_page.dart';
import 'package:flutter_mario_garcia_app/pages/operator/planta/detail/operator_planta_detail_page.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/register_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class OperatorPlantaListPage extends StatefulWidget {
  const OperatorPlantaListPage({super.key});

  @override
  State<OperatorPlantaListPage> createState() => _OperatorPlantaListPageState();
}

class _OperatorPlantaListPageState extends State<OperatorPlantaListPage> {
  final RegisterPlantaService _registerPlantaService = RegisterPlantaService();
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

  Future<List<RegisterPlanta>> getRegisters() async {
    return await _registerPlantaService.getByIdOperatorAndMonth(
        user!.id!, month!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Registros planta', color: Colors.white),
        actions: [
          IconButton(
              onPressed: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (BuildContext context) =>
                        const OperatorPlantaCreatePage(),
                  ),
                );

                if (res != null) {
                  if (res) {
                    refresh();
                  }
                }
              },
              icon: const Icon(Icons.add)),
        ],
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
      ),
    );
  }

  Widget _cardControlPeso(RegisterPlanta planta) {
    return GestureDetector(
      onTap: () async {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                OperatorPlantaDetailPage(planta: planta),
          ),
        );
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
                SizedBox(
                  width: 210,
                  child: Text(planta.planta ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis),
                ),
                CustomText(
                  text: '${planta.createdAt ?? ''} ${planta.hourInit ?? ''}',
                  size: 14,
                  weight: FontWeight.w300,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: planta.status ?? '',
                  size: 12,
                  color:
                      planta.status == 'FINALIZADO' ? Colors.red : Colors.green,
                  weight: FontWeight.w300,
                ),
                CustomText(
                  text: '${planta.totalDescarga ?? 0} kg.',
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

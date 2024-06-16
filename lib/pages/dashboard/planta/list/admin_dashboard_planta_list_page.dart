import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DashboardPlantaListPage extends StatefulWidget {
  final List<RegisterPlanta> plantaList;
  const DashboardPlantaListPage({super.key, required this.plantaList});

  @override
  State<DashboardPlantaListPage> createState() =>
      _DashboardPlantaListPageState();
}

class _DashboardPlantaListPageState extends State<DashboardPlantaListPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  UserModel? user;
  bool isHover = false;
  String? month;
  List<RegisterPlanta> registerList = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    registerList = widget.plantaList;
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Registros planta', color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: registerList.length,
        itemBuilder: (context, index) =>
            _cardregisterPlanta(registerList[index]),
      ),
    );
  }

  Widget _cardregisterPlanta(RegisterPlanta planta) {
    return GestureDetector(
      onTap: () async {
        // Navigator.push<void>(
        //   context,
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) =>
        //         AdminPlantaDetailPage(planta: planta),
        //   ),
        // );
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
                  child: Text(planta.planta ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis),
                ),
                CustomText(
                  text: '${planta.createdAt ?? ''} ${planta.hourInit ?? ''}',
                  size: 12,
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

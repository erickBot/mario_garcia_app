import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/data_provider.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/register_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';

import 'package:provider/provider.dart';

class SelectedData extends StatefulWidget {
  const SelectedData({super.key});

  @override
  State<SelectedData> createState() => _SelectedDataState();
}

class _SelectedDataState extends State<SelectedData> {
  final RegisterPlantaService _plantaService = RegisterPlantaService();
  final ControlPesoService _pesoService = ControlPesoService();

  //
  int? year;
  String? monthStr;
  UserModel? user;

  List<RegisterPlanta> plantaList = [];
  List<ControlPeso> muelleList = [];
  bool isLoading = true;
  int lastTimestamp = 0;
  int timestamp = 0;

  List<Map<String, dynamic>> intervalData = [
    {'name': 'Hace un dia', 'count': 1, 'interval': 'day'},
    {'name': 'Hace 1 semana', 'count': 7, 'interval': 'week'},
    {'name': 'Hace 2 semanas', 'count': 14, 'interval': 'week'},
    {'name': 'Este mes', 'count': 30, 'interval': 'month'},
    {'name': 'Hace 3 meses', 'count': 90, 'interval': 'month'},
    {'name': 'Hace 6 meses', 'count': 180, 'interval': 'month'},
    {'name': 'Hace 1 año', 'count': 365, 'interval': 'year'},
  ];

  Map<String, dynamic>? intervalSelected;

  int count = 1;
  String interval = 'day';
  double totalOrder = 0;
  double totalOrderHb = 0;
  double totalOrderRutina = 0;
  double totalOrderMembership = 0;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    year = DateTime.now().year;
    final month = DateTime.now().month;
    if (month.bitLength == 1) {
      monthStr = '0$month';
    } else {
      monthStr = '$month';
    }
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  void getRegistrosPlanta(int timestamp1, int timestamp2) async {
    plantaList = await _plantaService.getByPeriodo(timestamp1, timestamp2);
    getRegistrosMuelle(timestamp1, timestamp2);
  }

  void getRegistrosMuelle(int timestamp1, int timestamp2) async {
    muelleList = await _pesoService.getByPeriodo(timestamp1, timestamp2);
    refreshData();
  }

  void refreshData() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    int plantaCount = plantaList.length;
    int muelleCount = muelleList.length;

    dataProvider.setCurrentData(
        plantaCount, muelleCount, plantaList, muelleList);
  }

  @override
  Widget build(BuildContext context) {
    // final intervalProvider =
    //     Provider.of<CountIntervalProvider>(context, listen: false);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomText(text: 'Periodo'),
          const SizedBox(width: 5),
          // IconButton(icon: const Icon(Icons.refresh), onPressed: refreshData),
          Container(
            width: 180,
            height: 45,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton(
              // focusNode: departmentFocus,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Colors.white,
              underline: Container(),
              elevation: 3,
              isExpanded: true,
              menuMaxHeight: 250,
              hint: const Text(
                'Hace un dia',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              items: intervalData
                  .map((model) => DropdownMenuItem(
                        value: model,
                        child: Text(model['name'],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
                      ))
                  .toList(),
              value: intervalSelected,
              onChanged: (option) {
                intervalSelected = option;
                count = intervalSelected!['count'];
                timestamp = DateTime.now().millisecondsSinceEpoch; //actual
                lastTimestamp =
                    timestamp - (count * 24 * 60 * 60 * 1000); //hace 24 hrs
                getRegistrosPlanta(timestamp, lastTimestamp);
                refresh();
              },
            ),
          ),
        ],
      ),
    );
  }
}

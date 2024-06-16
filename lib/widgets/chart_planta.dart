import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/services/register_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPlanta extends StatefulWidget {
  const ChartPlanta({Key? key}) : super(key: key);

  @override
  State<ChartPlanta> createState() => _ChartPlantaState();
}

class _ChartPlantaState extends State<ChartPlanta> {
  List<String> months = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  List<String> monthName = [
    'ENE',
    'FEB',
    'MAR',
    'ABR',
    'MAY',
    'JUN',
    'JUL',
    'AGO',
    'SEP',
    'OCT',
    'NOV',
    'DIC'
  ];

  final RegisterPlantaService _plantaService = RegisterPlantaService();

  int? year;
  List<RegisterPlanta> ordersByDate = [];
  List<RegisterPlanta> orders = [];
  List<SalesData> list = [];
  String? nameStore;

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    getRegistrosPlanta();
  }

  void getRegistrosPlanta() async {
    orders = await _plantaService.getByYear(year.toString());

    setState(() {});
  }

  List<SalesData> setData() {
    int index = 0;
    ordersByDate.clear();
    list.clear();

    //
    if (orders.isNotEmpty) {
      months.forEach((month) {
        ordersByDate =
            orders.where((RegisterPlanta item) => item.month == month).toList();

        if (ordersByDate.isNotEmpty) {
          list.add(SalesData(monthName[index], ordersByDate.length.toDouble()));
        }

        index++;
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: .5, color: Colors.black54),
        color: Colors.white,
      ),
      child: Column(
        children: [
          CustomText(
              text: 'Despachos en Planta - $year',
              weight: FontWeight.w600,
              size: 16),
          const SizedBox(height: 20),
          Center(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                LineSeries<SalesData, String>(
                    color: Theme.of(context).primaryColor,
                    dataSource: setData(),
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}

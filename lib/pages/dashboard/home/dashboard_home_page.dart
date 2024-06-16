import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/widgets/cards_small.dart';
import 'package:flutter_mario_garcia_app/widgets/chart_muelle.dart';
import 'package:flutter_mario_garcia_app/widgets/chart_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/selected_data.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Tablero', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          flexibleSpace: Column(
            children: const [
              Spacer(),
              SelectedData(),
            ],
          ),
        ),
      ),
      body: ListView(
        children: const [
          OverviewCardsSmallScreen(),
          ChartPlanta(),
          ChartMuelle(),
        ],
      ),
    );
  }
}

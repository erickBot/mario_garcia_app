import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/dashboard/muelle/list/dashboard_muelle_list_page.dart';
import 'package:flutter_mario_garcia_app/pages/dashboard/planta/list/admin_dashboard_planta_list_page.dart';
import 'package:flutter_mario_garcia_app/providers/data_provider.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/widgets/info_card_small.dart';

import 'package:provider/provider.dart';

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  //
  int? year;
  String? monthStr;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
        //height: 400,
        child: Consumer<DataProvider>(
      builder: (_, value, __) => Column(
        children: [
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: 'Registros planta',
            value: value.currentPlantaCount.toString(),
            isActive: true,
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DashboardPlantaListPage(
                      plantaList: value.currentPlantaList),
                ),
              );
            },
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: 'Registros muelle',
            value: value.currentMuelleCount.toString(),
            isActive: true,
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DashboardMuelleListPage(
                      muelleList: value.currentMuelleList),
                ),
              );
            },
          ),
          SizedBox(
            height: width / 64,
          ),
        ],
      ),
    ));
  }
}

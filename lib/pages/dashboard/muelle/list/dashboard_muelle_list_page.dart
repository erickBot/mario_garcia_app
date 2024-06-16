import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class DashboardMuelleListPage extends StatefulWidget {
  final List<ControlPeso> muelleList;
  const DashboardMuelleListPage({super.key, required this.muelleList});

  @override
  State<DashboardMuelleListPage> createState() =>
      _DashboardMuelleListPageState();
}

class _DashboardMuelleListPageState extends State<DashboardMuelleListPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  UserModel? user;
  bool isHover = false;
  String? month;
  List<ControlPeso> registerMuelle = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    month = DateTime.now().month.toString();
    registerMuelle = widget.muelleList;
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros muelle'),
      ),
      body: ListView.builder(
        itemCount: registerMuelle.length,
        itemBuilder: (context, index) =>
            _cardControlPeso(registerMuelle[index]),
      ),
    );
  }

  Widget _cardControlPeso(ControlPeso control) {
    return GestureDetector(
      onTap: () {
        // Navigator.push<void>(
        //   context,
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) =>
        //         AdminMuelleDetailPage(control: control),
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

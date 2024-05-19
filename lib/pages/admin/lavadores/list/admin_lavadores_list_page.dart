import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/pages/admin/lavadores/create/admin_lavadores_create.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLavadoresListPage extends StatefulWidget {
  const AdminLavadoresListPage({super.key});

  @override
  State<AdminLavadoresListPage> createState() => _AdminLavadoresListPageState();
}

class _AdminLavadoresListPageState extends State<AdminLavadoresListPage> {
  final LavadorService _lavadorService = LavadorService();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Lavador>> getAll() async {
    return await _lavadorService.getAll();
  }

  void refresh() {
    setState(() {});
  }

  void delete(Lavador lavador) async {
    try {
      await _lavadorService.delete(lavador.id!);
      Fluttertoast.showToast(msg: 'Lavador eleminado con exito');
      refresh();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al eliminar lavador!');
      return;
    }
  }

  void showAlertDialog(Lavador lavador) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        delete(lavador);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      child: const CustomText(text: 'Si', color: Colors.white),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      child: const CustomText(text: 'No', color: Colors.white),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const CustomText(
          text: 'Estas seguro que quieres eliminar a este lavador?'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lavadores'),
          actions: [
            IconButton(
                onPressed: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute<bool>(
                      builder: (BuildContext context) =>
                          const AdminLavadoresCreate(),
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
          future: getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _cardLavador(snapshot.data![index]),
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

  Widget _cardLavador(Lavador lavador) {
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
              text: '${lavador.name} ${lavador.lastname}',
              size: 14,
              weight: FontWeight.w400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: lavador.createdAt, size: 14, weight: FontWeight.w300),
              IconButton(
                  onPressed: () {
                    showAlertDialog(lavador);
                  },
                  icon: const Icon(Icons.close, size: 20)),
            ],
          ),
        ],
      ),
    );
  }
}

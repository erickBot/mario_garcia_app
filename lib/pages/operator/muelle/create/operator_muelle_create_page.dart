import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OperatorMuelleCreatePage extends StatefulWidget {
  const OperatorMuelleCreatePage({super.key});

  @override
  State<OperatorMuelleCreatePage> createState() =>
      _OperatorMuelleCreatePageState();
}

class _OperatorMuelleCreatePageState extends State<OperatorMuelleCreatePage> {
  final ControlPesoService _controlPesoService = ControlPesoService();
  final LavadorService _lavadorService = LavadorService();

  final TextEditingController _embarcacionController = TextEditingController();
  final TextEditingController _driverEmbController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();

  UserModel? user;
  List<Lavador> lavadores = [];
  Lavador? lavador;
  String? tipo;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    getLabadores();
  }

  void refresh() {
    setState(() {});
  }

  void getLabadores() async {
    lavadores = await _lavadorService.getAll();
    refresh();
  }

  void create() async {
    try {
      String embarcacion = _embarcacionController.text;
      String driverEmb = _driverEmbController.text;
      String driver = _driverController.text;
      String placa = _placaController.text;

      String date = DateFormat.yMd().format(DateTime.now()).toString();

      String month = DateTime.now().month.toString();
      String year = DateTime.now().year.toString();
      String hourInit = DateFormat.jm().format(DateTime.now()).toString();

      if (embarcacion.isEmpty && driverEmb.isEmpty) {
        Fluttertoast.showToast(
            msg:
                'Embarcacion y nombre de operador de la embarcacion son obligatorios');
        return;
      }

      ControlPeso data = ControlPeso(
        date: date,
        hourInit: hourInit,
        month: month,
        year: year,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        embarcacion: embarcacion,
        operatorEmbarcacion: driverEmb,
        idOperator: user!.id!,
        conductor: driver,
        placa: placa,
        tipo: tipo,
        lavadores: [],
        controlPesoOperator: '${user?.name ?? ''} ${user?.lastname ?? ''}',
        status: 'INICIADO',
      );

      await _controlPesoService.create(data);
      Fluttertoast.showToast(msg: 'Registro creado con exito!');

      Future.delayed(const Duration(seconds: 1), () {
        // _progressDialog?.close();
        Navigator.pop(context, true);
      });
    } catch (e) {
      // _progressDialog?.close();
      Fluttertoast.showToast(msg: 'Ocurrio un error!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro muelle'),
      ),
      body: ListView(
        children: [
          _inputEmbarcacion(),
          _inputOperatorEmbarcacion(),
          _inputDriver(),
          _inputPlaca(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _inputEmbarcacion() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _embarcacionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Embarcacion',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          //suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _inputOperatorEmbarcacion() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _driverEmbController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Operador Embarcacion',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          //suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _inputDriver() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _driverController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Conductor',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          //suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _inputPlaca() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _placaController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Placa',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black54, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          //suffixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }

  Widget _button() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: create,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
        ),
        child: const CustomText(
            text: 'CREAR REGISTRO',
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}

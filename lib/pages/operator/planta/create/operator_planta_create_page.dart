import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:flutter_mario_garcia_app/services/register_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OperatorPlantaCreatePage extends StatefulWidget {
  const OperatorPlantaCreatePage({super.key});

  @override
  State<OperatorPlantaCreatePage> createState() =>
      _OperatorPlantaCreatePageState();
}

class _OperatorPlantaCreatePageState extends State<OperatorPlantaCreatePage> {
  final RegisterPlantaService _registerPlantaService = RegisterPlantaService();
  final TextEditingController _totalDescargadoController =
      TextEditingController();
  final TextEditingController _bathRecibidoController = TextEditingController();
  final TextEditingController _reportePesajeController =
      TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _wzeroController = TextEditingController();
  final TextEditingController _wspanController = TextEditingController();
  final TextEditingController _wvalController = TextEditingController();
  final TextEditingController _coefCalibrationController =
      TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _embarcacionController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  UserModel? user;
  List<Lavador> lavadores = [];
  Lavador? lavador;
  String? tipo;
  String? hourRunSelected;
  String? hourLeaveSelected;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
  }

  void refresh() {
    setState(() {});
  }

  void create() async {
    try {
      String embarcacion = _embarcacionController.text;
      String matricula = _matriculaController.text;
      String batch = _bathRecibidoController.text;
      String descargado = _totalDescargadoController.text;
      String pesaje = _reportePesajeController.text;
      String placa = _placaController.text;
      String zero = _wzeroController.text;
      String span = _wspanController.text;
      String val = _wvalController.text;
      String reportePesaje = _reportePesajeController.text;
      String coeficiente = _coefCalibrationController.text;
      String date = DateFormat.yMd().format(DateTime.now()).toString();
      String month = DateTime.now().month.toString();
      String year = DateTime.now().year.toString();

      if (embarcacion.isEmpty ||
          matricula.isEmpty ||
          reportePesaje.isEmpty ||
          placa.isEmpty ||
          batch.isEmpty ||
          descargado.isEmpty ||
          pesaje.isEmpty ||
          zero.isEmpty ||
          span.isEmpty ||
          val.isEmpty ||
          coeficiente.isEmpty) {
        Fluttertoast.showToast(msg: 'Todos los campos son obligatorios');
        return;
      }

      double totalDescargado = double.parse(descargado);
      int batchRecibio = int.parse(batch);
      int wzero = int.parse(zero);
      int wspan = int.parse(span);
      double wval = double.parse(val);
      double coefCaibration = double.parse(coeficiente);

      RegisterPlanta planta = RegisterPlanta(
        totalDescarga: totalDescargado,
        batchRecibido: batchRecibio,
        reportPesaje: reportePesaje,
        typeTransport: 'Camara Isotermica',
        placa: placa,
        hourInit: hourRunSelected,
        hourEnd: hourLeaveSelected,
        cuentaWzero: wzero,
        cuentaWspan: wspan,
        cuentaWval: wval,
        coeficienteCal: coefCaibration,
        idOperator: user!.id,
        nameOperator: '${user!.name} ${user!.lastname}',
        month: month,
        year: year,
        createdAt: date,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      Fluttertoast.showToast(msg: 'Registro creado con exito!');

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Ocurrio un error!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro planta'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(width: .5, color: Colors.black54),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _openHourRunSelected(),
                _openHourLeaveSelected(),
              ],
            ),
          ),
          _totalDescargado(),
          _batchRecibido(),
          _reportePesaje(),
          _placa(),
          _cuentaWzero(),
          _cuentaWspan(),
          _cuentaWval(),
          _coeficienteCalibracion(),
          _inputMatricula(),
          _inputEmbarcacion(),
          _comment(),
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

  Widget _inputMatricula() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _matriculaController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Matricula',
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

  Widget _totalDescargado() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _totalDescargadoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Total descargado (kg)',
          labelText: 'Total descargado (kg)',
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

  Widget _batchRecibido() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _bathRecibidoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Batch recibido',
          labelText: 'Batch recibido',
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

  Widget _reportePesaje() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _reportePesajeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Reporte pesaje',
          labelText: 'Reporte pesaje',
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

  Widget _placa() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _placaController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Numero de placa',
          labelText: 'Numero de placa',
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

  Widget _cuentaWzero() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _wzeroController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Cuenta wzero',
          labelText: 'Cuenta wzero',
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

  Widget _cuentaWspan() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _wspanController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Cuenta wspan',
          labelText: 'Cuenta wspan',
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

  Widget _cuentaWval() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _wvalController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Cuenta wval',
          labelText: 'Cuenta wval',
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

  Widget _coeficienteCalibracion() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _coefCalibrationController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Coeficiente calibracion',
          labelText: 'Coeficiente calibracion',
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

  Widget _comment() {
    return Container(
      // width: 130,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: _commentController,
        keyboardType: TextInputType.text,
        maxLength: 150,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Comentarios',
          labelText: 'Comentarios',
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

  Widget _openHourRunSelected() {
    return Expanded(
      //width: 150,
      child: DateTimePicker(
        type: DateTimePickerType.time,
        dateMask: 'd MMM, yyyy',
        initialValue: hourRunSelected,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event, color: Colors.black),
        //dateLabelText: 'Fecha final',
        timeLabelText: 'H.Inicio',
        selectableDayPredicate: (date) {
          // Disable weekend days to select from the calendar
          // if (date.weekday == 6 || date.weekday == 7) {
          //   return false;
          // }

          return true;
        },
        onChanged: (val) {
          hourRunSelected = val;
          refresh();
        },
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
      ),
    );
  }

  Widget _openHourLeaveSelected() {
    return Expanded(
      // width: 150,
      child: DateTimePicker(
        type: DateTimePickerType.time,
        dateMask: 'd MMM, yyyy',
        initialValue: hourLeaveSelected,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event, color: Colors.black),
        //dateLabelText: 'Fecha final',
        timeLabelText: 'H.Final',
        selectableDayPredicate: (date) {
          // Disable weekend days to select from the calendar
          // if (date.weekday == 6 || date.weekday == 7) {
          //   return false;
          // }

          return true;
        },
        onChanged: (val) {
          hourLeaveSelected = val;
          refresh();
        },
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
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

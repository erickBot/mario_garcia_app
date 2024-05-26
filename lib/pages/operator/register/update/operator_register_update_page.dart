import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:flutter_mario_garcia_app/utils/shared_preferences.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OperatorRegisterUpdatePage extends StatefulWidget {
  final ControlPeso control;
  const OperatorRegisterUpdatePage({super.key, required this.control});

  @override
  State<OperatorRegisterUpdatePage> createState() =>
      _OperatorRegisterUpdatePageState();
}

class _OperatorRegisterUpdatePageState
    extends State<OperatorRegisterUpdatePage> {
  final LavadorService _lavadorService = LavadorService();
  final ControlPesoService _controlPesoService = ControlPesoService();
  final SharedPref _prefs = SharedPref();
  final TextEditingController _numCajasController = TextEditingController();
  final TextEditingController _numCajasRecuperadasCon = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  UserModel? user;
  ControlPeso? control;
  List<Lavador> lavadores = [];
  List<Lavador> lavadorSelected = [];
  List<double> pesos = [];
  Lavador? lavador;
  int quantityPeso = 0;
  double totalPesos = 0;
  String? vascula;

  //
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    control = widget.control;
    getLavadores();
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  void getLavadores() async {
    lavadores = await _lavadorService.getAll();
    lavadorSelected = control?.lavadores ?? [];
    pesos = List<double>.from(await _prefs.read('peso'));
    vascula = await _prefs.read('vascula');
    getTotal();
    refresh();
  }

  void getTotal() {
    totalPesos = 0;
    for (double element in pesos) {
      totalPesos = totalPesos + element;
    }

    quantityPeso = pesos.length;

    refresh();
  }

  void addPeso() {
    String inputPeso = _pesoController.text;

    if (inputPeso.isEmpty) {
      Fluttertoast.showToast(msg: 'Primero ingrese un peso!');
      return;
    }

    double peso = double.parse(inputPeso);

    pesos.add(peso);

    _pesoController.clear();
    _prefs.save('peso', pesos);

    getTotal();
  }

  void addLavador(Lavador lavador) {
    int index =
        lavadorSelected.indexWhere((element) => element.id == lavador.id);

    if (index == -1) {
      lavadorSelected.add(lavador);
    } else {
      Fluttertoast.showToast(msg: 'Ya fue agregado!');
    }

    refresh();
  }

  void saveLavadores() async {
    try {
      List<Map<String, dynamic>> list = [];

      for (final item in lavadorSelected) {
        list.add(item.toJson());
      }

      if (lavadorSelected.isEmpty) {
        Fluttertoast.showToast(msg: 'No se selecciono lavadores');
        return;
      }

      Map<String, dynamic> data = {
        'lavadores': list,
      };

      await _controlPesoService.update(data, control!.id!);

      Fluttertoast.showToast(msg: 'Datos guardados!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrio un errror al guardar lista!');
      print(e);
      return;
    }
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        addPeso();
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
      title: const CustomText(text: '¿Esta seguro de ingresar este peso?'),
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
        title: Text('${control?.tipo ?? ''} DE PRODUCTO'),
      ),
      body: ListView(
        children: [
          _cardEmbarcacionInfo('Embarcación: ${control?.embarcacion ?? ''}',
              'Operador: ${control?.operatorEmbarcacion ?? ''}'),
          _cardEmbarcacionInfo('Placa camión: ${control?.placa ?? ''}',
              'Conductor: ${control?.conductor ?? ''}'),
          _cardInputInfo(),
          _cardLavadores(),
          _cardPesos(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _cardEmbarcacionInfo(String vehicle, String name) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: vehicle, weight: FontWeight.w400),
          CustomText(text: name, weight: FontWeight.w300),
        ],
      ),
    );
  }

  Widget _cardInputInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const CustomText(
                        text: 'Cajas entregadas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _numCajasController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.black54, width: .5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.black54, width: .5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                        ),
                        prefixStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        hintStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        focusColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    const CustomText(
                        text: 'Cajas recuperadas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _numCajasController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.black54, width: .5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.black54, width: .5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                        ),
                        prefixStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        hintStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        focusColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardLavadores() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Lavadores', weight: FontWeight.w500),
              TextButton(
                  onPressed: saveLavadores,
                  child: const CustomText(
                      text: 'Guardar',
                      color: Colors.black,
                      weight: FontWeight.w600)),
            ],
          ),
          _dropDown(),
          Wrap(
            children: lavadorSelected
                .map((Lavador lavador) => Padding(
                      padding: const EdgeInsets.all(3),
                      child: Chip(label: Text(lavador.name)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _dropDown() {
    return Container(
      //margin: const EdgeInsets.sy,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black54),
      ),
      child: DropdownButton<Lavador>(
        value: lavador,
        hint: const Text('Selecciona un lavador'),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 14,
        style: const TextStyle(color: Colors.black),
        underline: Container(),
        onChanged: (Lavador? value) {
          // This is called when the user selects an item.
          addLavador(value!);
        },
        items: lavadores.map<DropdownMenuItem<Lavador>>((Lavador value) {
          return DropdownMenuItem<Lavador>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }

  Widget _cardPesos() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(text: 'Ingresar peso', weight: FontWeight.w500),
              CustomText(text: '($quantityPeso) $totalPesos kg')
            ],
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                    title: const CustomText(text: 'Electrónica', size: 14),
                    value: 'Electrónica',
                    groupValue: vascula,
                    onChanged: (value) {
                      vascula = value;
                      _prefs.save('vascula', vascula);
                      refresh();
                    }),
              ),
              Expanded(
                child: RadioListTile(
                    title: const CustomText(text: 'Romana', size: 14),
                    value: 'Romana',
                    groupValue: vascula,
                    onChanged: (value) {
                      vascula = value;
                      _prefs.save('vascula', vascula);
                      refresh();
                    }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: Colors.black54, width: .5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: Colors.black54, width: .5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(color: Colors.black, width: .5),
                    ),
                    prefixStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                    hintStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                    focusColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: () {
                  if (vascula == null) {
                    Fluttertoast.showToast(
                        msg: 'Seleccione un tipo de balanza');
                    return;
                  }
                  showAlertDialog();
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
        ),
        child: const CustomText(
            text: 'FINALIZAR',
            size: 16,
            weight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}

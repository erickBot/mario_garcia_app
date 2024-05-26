import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/descuento.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/control_peso_service.dart';
import 'package:flutter_mario_garcia_app/services/lavador_service.dart';
import 'package:flutter_mario_garcia_app/utils/shared_preferences.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _cajaLlenaController = TextEditingController();
  final TextEditingController _cajaVaciaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _nameDescuentoPesoCon = TextEditingController();
  final TextEditingController _valueDescuentoPesoCon = TextEditingController();
  final TextEditingController _nameGastosController = TextEditingController();
  final TextEditingController _valueGastoController = TextEditingController();
  final TextEditingController _commentsControler = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();

  UserModel? user;
  ControlPeso? control;
  List<Lavador> lavadores = [];
  List<Lavador> lavadorSelected = [];
  List<double> pesos = [];
  List<Descuento> descuentoPesoList = [];
  List<Descuento> gastosList = [];
  Lavador? lavador;
  int quantityPeso = 0;
  int quantityDescuentoPeso = 0;
  int quantityGastos = 0;
  double totalAddPesos = 0;
  double totalRemovePeso = 0;
  double pesoLiquido = 0;
  double gastos = 0;
  String? vascula;
  String? hourRunSelected;
  String? hourLeaveSelected;

  //
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    control = widget.control;
    _numCajasController.text = control?.totalBox?.toString() ?? '0';
    _numCajasRecuperadasCon.text = control?.recoveredBox?.toString() ?? '0';
    _cajaLlenaController.text = control?.boxNoEmpty?.toString() ?? '0';
    _cajaVaciaController.text = control?.boxEmpty?.toString() ?? '0';
    _driverController.text = control?.conductor ?? '';
    _placaController.text = control?.placa ?? '';
    getLavadores();
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  void getLavadores() async {
    lavadores = await _lavadorService.getAll();
    lavadorSelected = control?.lavadores ?? [];
    pesos = List<double>.from(await _prefs.read('peso') ?? []);
    vascula = await _prefs.read('vascula');
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
        await _prefs.read('descuento_peso') ?? []);

    for (final element in list) {
      descuentoPesoList.add(Descuento.fromJson(element));
    }

    getSumAddPeso();
    getSumRemovePeso();
    getGastos();
    refresh();
  }

  void getGastos() async {
    List<Map<String, dynamic>> list =
        List<Map<String, dynamic>>.from(await _prefs.read('gastos') ?? []);

    for (final element in list) {
      gastosList.add(Descuento.fromJson(element));
    }

    getSumGastos();
  }

  void getSumGastos() {
    gastos = 0;
    for (Descuento element in gastosList) {
      gastos = gastos + element.value;
    }

    quantityGastos = gastosList.length;

    refresh();
  }

  void addGasto() {
    String name = _nameGastosController.text;
    String inputValor = _valueGastoController.text;

    if (name.isEmpty) {
      Fluttertoast.showToast(msg: 'Primero ingrese un nombre del gasto!');
      return;
    }

    if (inputValor.isEmpty) {
      Fluttertoast.showToast(msg: 'No ingreso el valor del gasto!');
      return;
    }

    double valor = double.parse(inputValor);

    Descuento descuento = Descuento(name: name, value: valor);

    gastosList.add(descuento);

    _nameGastosController.clear();
    _valueGastoController.clear();
    _prefs.save('gastos', gastosList);

    getSumGastos();
  }

  void getSumAddPeso() {
    totalAddPesos = 0;
    for (double element in pesos) {
      totalAddPesos = totalAddPesos + element;
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

    getSumAddPeso();
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

  void removeLavador(Lavador lavador) {
    lavadorSelected.removeWhere((element) => element.id == lavador.id);
    refresh();
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

//descontar pesos
  void addDescuentoPeso() {
    String name = _nameDescuentoPesoCon.text;
    String inputPeso = _valueDescuentoPesoCon.text;

    if (name.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Primero ingrese un nombre del peso que va descontar!');
      return;
    }

    if (inputPeso.isEmpty) {
      Fluttertoast.showToast(msg: 'Primero ingrese un peso!');
      return;
    }

    double peso = double.parse(inputPeso);

    Descuento descuento = Descuento(name: name, value: peso);

    descuentoPesoList.add(descuento);

    _nameDescuentoPesoCon.clear();
    _valueDescuentoPesoCon.clear();
    _prefs.save('descuento_peso', descuentoPesoList);

    getSumRemovePeso();
  }

  void removeDescuentoPeso(Descuento descuento) {
    descuentoPesoList.removeWhere((element) => element.name == descuento.name);
    _prefs.save('descuento_peso', descuentoPesoList);

    getSumRemovePeso();
  }

  void getSumRemovePeso() {
    totalRemovePeso = 0;
    totalAddPesos = 0;
    pesoLiquido = 0;

    for (double element in pesos) {
      totalAddPesos = totalAddPesos + element;
    }
    for (Descuento element in descuentoPesoList) {
      totalRemovePeso = totalRemovePeso + element.value;
    }

    quantityDescuentoPeso = descuentoPesoList.length;
    pesoLiquido = totalAddPesos - totalRemovePeso;

    refresh();
  }

  void removeGasto(Descuento gasto) {
    gastosList.removeWhere((element) => element.name == gasto.name);
    _prefs.save('gastos', gastosList);

    getSumGastos();
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

  void saveInfoCajas() async {
    try {
      int cajasEntregadas = 0;
      int cajasRecuperadas = 0;
      int cajasLLenas = 0;
      int cajasVacias = 0;

      if (_numCajasController.text.isNotEmpty) {
        cajasEntregadas = int.parse(_numCajasController.text);
      }
      if (_numCajasRecuperadasCon.text.isNotEmpty) {
        cajasRecuperadas = int.parse(_numCajasRecuperadasCon.text);
      }
      if (_cajaLlenaController.text.isNotEmpty) {
        cajasLLenas = int.parse(_cajaLlenaController.text);
      }
      if (_cajaVaciaController.text.isNotEmpty) {
        cajasVacias = int.parse(_cajaVaciaController.text);
      }

      Map<String, dynamic> data = {
        'total_box': cajasEntregadas,
        'recovered_box': cajasRecuperadas,
        'box_no_empty': cajasLLenas,
        'box_empty': cajasVacias,
      };

      await _controlPesoService.update(data, control!.id!);

      Fluttertoast.showToast(msg: 'Datos guardados!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrio un errror al guardar lista!');
      print(e);
      return;
    }
  }

  void update() async {
    try {
      int cajasEntregadas = 0;
      int cajasRecuperadas = 0;
      int cajasLLenas = 0;
      int cajasVacias = 0;
      String placa = _placaController.text;
      String driver = _driverController.text;
      String hourEnd = DateFormat.jm().format(DateTime.now()).toString();
      String date = DateFormat.yMd().format(DateTime.now()).toString();

      if (hourRunSelected == null || hourLeaveSelected == null) {
        Fluttertoast.showToast(
            msg: 'Debe ingresar la hora de carga y hora de salida!');
        return;
      }

      if (placa.isEmpty || driver.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Debe ingresar placa del vehiculo y nombre del condcutor!');
        return;
      }

      if (_numCajasController.text.isNotEmpty) {
        cajasEntregadas = int.parse(_numCajasController.text);
      }
      if (_numCajasRecuperadasCon.text.isNotEmpty) {
        cajasRecuperadas = int.parse(_numCajasRecuperadasCon.text);
      }
      if (_cajaLlenaController.text.isNotEmpty) {
        cajasLLenas = int.parse(_cajaLlenaController.text);
      }
      if (_cajaVaciaController.text.isNotEmpty) {
        cajasVacias = int.parse(_cajaVaciaController.text);
      }

      if (lavadorSelected.isEmpty) {
        Fluttertoast.showToast(msg: 'Debe seleccionar a los lavadores!');
        return;
      }

      if (pesos.isEmpty) {
        Fluttertoast.showToast(msg: 'Debe ingresar los pesos!');
        return;
      }

      List<Map<String, dynamic>> list = [];

      for (final item in lavadorSelected) {
        list.add(item.toJson());
      }

      List<Map<String, dynamic>> descuentos = [];

      for (final item in descuentoPesoList) {
        descuentos.add(item.toJson());
      }

      List<Map<String, dynamic>> newGastos = [];

      for (final item in gastosList) {
        newGastos.add(item.toJson());
      }

      Map<String, dynamic> data = {
        'total_box': cajasEntregadas,
        'recovered_box': cajasRecuperadas,
        'box_no_empty': cajasLLenas,
        'box_empty': cajasVacias,
        'lavadores': list,
        'pesos': pesos,
        'descuento_peso': descuentos,
        'gastos': newGastos,
        'hour_run': hourRunSelected,
        'hour_leave': hourLeaveSelected,
        'bascula': vascula,
        'conductor': driver,
        'placa': placa,
        'comment': _commentsControler.text,
        'hour_end': hourEnd,
        'id_operator': user!.id,
        'operator': '${user!.name} ${user!.lastname}',
        'status': 'FINALIZADO',
        'total_weight': pesoLiquido,
        'created_at': date,
      };

      await _controlPesoService.update(data, control!.id!);

      Fluttertoast.showToast(msg: 'Datos actualizados!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrio un errror al actualizar registro!');
      print(e);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${control?.tipo ?? ''} DE PRODUCTO'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          _cardEmbarcacionInfo('Embarcación: ${control?.embarcacion ?? ''}',
              'Operador: ${control?.operatorEmbarcacion ?? ''}'),
          // _cardEmbarcacionInfo('Placa camión: ${control?.placa ?? ''}',
          //     'Conductor: ${control?.conductor ?? ''}'),
          _cardDriver(),
          _cardInputInfo(),
          _cardLavadores(),
          _cardPesos(),
          _descuentoPeso(),
          _cardGastos(),
          _cardPesoLiquido(),
          _inputComment(),
        ],
      ),
      bottomNavigationBar: _button(),
    );
  }

  Widget _cardPesoLiquido() {
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
          const CustomText(text: 'Peso liquido', weight: FontWeight.w400),
          CustomText(text: '$pesoLiquido kg', weight: FontWeight.w300),
        ],
      ),
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

  Widget _cardDriver() {
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
          const CustomText(
              text: 'Informacion del camión', weight: FontWeight.w400),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: _placaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Placa vehículo',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: .5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: .5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: .5),
                ),
                prefixStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                hintStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                focusColor: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              controller: _driverController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Conductor',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: .5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: .5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: .5),
                ),
                prefixStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                hintStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                focusColor: Colors.black,
              ),
            ),
          ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                  text: 'Información de cajas', weight: FontWeight.w500),
              TextButton(
                  onPressed: saveInfoCajas,
                  child: const CustomText(
                      text: 'Guardar',
                      color: Colors.black,
                      weight: FontWeight.w600)),
            ],
          ),
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
                      controller: _numCajasRecuperadasCon,
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
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const CustomText(
                        text: 'Cajas llenas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cajaLlenaController,
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
                        text: 'Cajas vacias', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cajaVaciaController,
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
                .map((Lavador lavador) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Chip(label: Text(lavador.name)),
                        ),
                        Positioned(
                          top: -8,
                          right: -10,
                          child: IconButton(
                              onPressed: () => removeLavador(lavador),
                              icon: const Icon(Icons.close)),
                        ),
                      ],
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
              CustomText(text: '($quantityPeso) $totalAddPesos kg')
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
              GestureDetector(
                onTap: () {
                  if (vascula == null) {
                    Fluttertoast.showToast(
                        msg: 'Seleccione un tipo de balanza');
                    return;
                  }
                  showAlertDialog();
                },
                child: const CircleAvatar(
                  child: Icon(Icons.add),
                ),
              ),
              // FloatingActionButton(
              //   onPressed: () {
              //     if (vascula == null) {
              //       Fluttertoast.showToast(
              //           msg: 'Seleccione un tipo de balanza');
              //       return;
              //     }
              //     showAlertDialog();
              //   },
              //   child: const Icon(Icons.add),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descuentoPeso() {
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
              const CustomText(text: 'Descontar peso', weight: FontWeight.w500),
              CustomText(text: '($quantityDescuentoPeso) $totalRemovePeso kg')
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameDescuentoPesoCon,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Nombre',
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
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: _valueDescuentoPesoCon,
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
              const SizedBox(width: 10),
              GestureDetector(
                onTap: addDescuentoPeso,
                child: const CircleAvatar(
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          Wrap(
            children: descuentoPesoList
                .map((model) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Chip(
                            label: CustomText(
                                text:
                                    '${model.name}: ${model.value.toString()} kg.'),
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -10,
                          child: IconButton(
                              onPressed: () {
                                removeDescuentoPeso(model);
                              },
                              icon: const Icon(Icons.close)),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _cardGastos() {
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
              const CustomText(text: 'Gastos', weight: FontWeight.w500),
              CustomText(text: '($quantityGastos) S/. $gastos')
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameGastosController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Nombre',
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
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: _valueGastoController,
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
              const SizedBox(width: 10),
              GestureDetector(
                onTap: addGasto,
                child: const CircleAvatar(
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          Wrap(
            children: gastosList
                .map((model) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Chip(
                            label: CustomText(
                                text:
                                    '${model.name}: S/. ${model.value.toString()}'),
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -10,
                          child: IconButton(
                              onPressed: () {
                                removeGasto(model);
                              },
                              icon: const Icon(Icons.close)),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: update,
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
        timeLabelText: 'Inicio Carga',
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
        timeLabelText: 'Salida',
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

  Widget _inputComment() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: _commentsControler,
        keyboardType: TextInputType.text,
        maxLength: 150,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Observaciones',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black54, width: .5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black54, width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: .5),
          ),
          prefixStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          focusColor: Colors.black,
        ),
      ),
    );
  }
}

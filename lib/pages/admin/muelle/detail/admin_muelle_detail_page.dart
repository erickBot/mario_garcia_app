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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AdminMuelleDetailPage extends StatefulWidget {
  final ControlPeso control;
  const AdminMuelleDetailPage({super.key, required this.control});

  @override
  State<AdminMuelleDetailPage> createState() => _AdminMuelleDetailPageState();
}

class _AdminMuelleDetailPageState extends State<AdminMuelleDetailPage> {
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
  double totalDescuentoPesos = 0;
  double totalPeso = 0;
  double totalGastos = 0;

  //
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    control = widget.control;
    pesoLiquido = control?.totalWeight ?? 0;
    setSumDescuentosPesos();
    setSumGastos();
    setSumPesos();
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  //totaliza el total de pesos descontados
  void setSumDescuentosPesos() {
    totalDescuentoPesos = 0;
    for (final item in control!.descuentoPesos!) {
      totalDescuentoPesos = totalDescuentoPesos + item.value;
    }
  }

  //totaliza el total de pesos
  void setSumPesos() {
    totalPeso = 0;
    for (final item in control!.pesos!) {
      totalPeso = totalPeso + item;
    }
  }

  //totaliza el total de gastos
  void setSumGastos() {
    totalGastos = 0;
    for (final item in control!.gastos!) {
      totalGastos = totalGastos + item.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro en el muelle'),
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
                CustomText(
                    text: 'H.Inicio: ${control?.hourInit ?? '   '}',
                    weight: FontWeight.w400),
                CustomText(
                    text: 'H.Final: ${control?.hourEnd ?? '        '}',
                    weight: FontWeight.w400),
              ],
            ),
          ),
          _cardEmbarcacion(),
          _cardDriver(),
          _cardLavadores(),
          _cardPesos(),
          _descuentoPeso(),
          _cardGastos(),
          _cardInputInfo(),
          _cardPesoLiquido(),
          _cardComments(),
          _cardResponsable(),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: CustomText(text: 'ANEXOS'),
          ),
          _cardImage(),
        ],
      ),
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
          const CustomText(text: 'Peso a liquidar', weight: FontWeight.w400),
          CustomText(text: '$pesoLiquido kg', weight: FontWeight.w300),
        ],
      ),
    );
  }

  Widget _cardComments() {
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
          const CustomText(text: 'Observaciones', weight: FontWeight.w400),
          CustomText(text: control?.comment ?? '', weight: FontWeight.w300),
        ],
      ),
    );
  }

  Widget _cardResponsable() {
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
          const CustomText(text: 'Responsable', weight: FontWeight.w400),
          CustomText(
              text: control?.controlPesoOperator ?? '',
              weight: FontWeight.w300),
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
              text: 'Información del camión', weight: FontWeight.w400),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(FontAwesomeIcons.bus, size: 15),
              CustomText(
                  text: '  ${control?.placa ?? ''}', weight: FontWeight.w300),
            ],
          ),
          Row(
            children: [
              const Icon(FontAwesomeIcons.user, size: 15),
              CustomText(
                  text: '  ${control?.conductor ?? ''}',
                  weight: FontWeight.w300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardEmbarcacion() {
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
              text: 'Información de la embarcación', weight: FontWeight.w400),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(FontAwesomeIcons.ship, size: 15),
              CustomText(
                  text: '  ${control?.embarcacion ?? ''}',
                  weight: FontWeight.w300),
            ],
          ),
          Row(
            children: [
              const Icon(FontAwesomeIcons.user, size: 15),
              CustomText(
                  text: '  ${control?.operatorEmbarcacion ?? ''}',
                  weight: FontWeight.w300),
            ],
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
          const CustomText(
              text: 'Información de cajas', weight: FontWeight.w500),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const CustomText(
                        text: 'Entregadas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    CustomText(
                        text: control?.totalBox?.toString() ?? '0',
                        weight: FontWeight.w300),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    const CustomText(
                        text: 'Eecuperadas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    CustomText(
                        text: control?.recoveredBox?.toString() ?? '0',
                        weight: FontWeight.w300),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const CustomText(text: 'Perdidas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    CustomText(
                        text: '${control?.boxLost ?? 0}',
                        weight: FontWeight.w300),
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
                    const CustomText(text: 'Llenas', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    CustomText(
                        text: control?.boxNoEmpty?.toString() ?? '0',
                        weight: FontWeight.w300),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    const CustomText(text: 'Vacias', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    CustomText(
                        text: control?.boxEmpty?.toString() ?? '0',
                        weight: FontWeight.w300),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const CustomText(text: 'Total', weight: FontWeight.w400),
                    const SizedBox(height: 8),
                    control!.totalBox != null
                        ? CustomText(
                            text:
                                '${control!.totalBox! + control!.recoveredBox!}',
                            weight: FontWeight.w300)
                        : const CustomText(text: '0', weight: FontWeight.w300),
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
          const CustomText(text: 'Lavadores', weight: FontWeight.w500),
          Wrap(
            children: control!.lavadores!
                .map((Lavador lavador) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Chip(label: Text(lavador.name)),
                        ),
                      ],
                    ))
                .toList(),
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
              const CustomText(
                  text: 'Descuento pesos', weight: FontWeight.w500),
              CustomText(
                  text: '$totalDescuentoPesos kg.', weight: FontWeight.w300),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            children: control!.descuentoPesos!
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
              const CustomText(text: 'Total Gastos', weight: FontWeight.w500),
              CustomText(text: 'S/. $totalGastos', weight: FontWeight.w300),
            ],
          ),
          Wrap(
            children: control!.gastos!
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
                      ],
                    ))
                .toList(),
          ),
        ],
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
              const CustomText(
                  text: 'Total de la suma de bote', weight: FontWeight.w500),
              CustomText(
                  text: '(${control?.pesos?.length ?? 0})$totalPeso kg.',
                  weight: FontWeight.w300),
            ],
          ),
          CustomText(
              text: 'Balanza ${control?.bascula ?? ''}',
              weight: FontWeight.w300),
        ],
      ),
    );
  }

  Widget _cardImage() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: control!.imageUrl != null
          ? FadeInImage(
              placeholder: const AssetImage('assets/img/jar-loading.gif'),
              image: NetworkImage(control!.imageUrl!),
            )
          : Image.asset('assets/img/no-image.png'),
    );
  }
}

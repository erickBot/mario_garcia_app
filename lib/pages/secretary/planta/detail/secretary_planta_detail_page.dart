import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/business.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';
import 'package:flutter_mario_garcia_app/providers/user_provider.dart';
import 'package:flutter_mario_garcia_app/services/business_service.dart';
import 'package:flutter_mario_garcia_app/services/cloudinary_service.dart';
import 'package:flutter_mario_garcia_app/services/plantas_service.dart';
import 'package:flutter_mario_garcia_app/services/register_planta.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SecretaryPlantaDetailPage extends StatefulWidget {
  final RegisterPlanta planta;
  const SecretaryPlantaDetailPage({super.key, required this.planta});

  @override
  State<SecretaryPlantaDetailPage> createState() =>
      _SecretaryPlantaDetailPageState();
}

class _SecretaryPlantaDetailPageState extends State<SecretaryPlantaDetailPage> {
  final RegisterPlantaService _registerPlantaService = RegisterPlantaService();
  final PlantasService _plantasService = PlantasService();
  final BusinessService _businessService = BusinessService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  UserModel? user;
  List<Lavador> lavadores = [];
  Lavador? lavador;
  String? tipo;
  String? hourRunSelected;
  String? hourLeaveSelected;
  List<Business> businessList = [];
  List<Business> plantas = [];
  Business? bussiness;
  Business? plantaIndustrial;
  XFile? pickedFile;
  File? imageFile;
  String? imageUrl;
  List<File> fileList = [];
  List<String> images = [];
  RegisterPlanta? planta;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    planta = widget.planta;
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  Future imageSelected(ImageSource imageSource) async {
    pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      fileList.add(imageFile!);
    }

    Navigator.pop(context);
    refresh();
  }

  void showAlertDialogImage() {
    Widget galleryButton = ElevatedButton(
      onPressed: () => imageSelected(ImageSource.gallery),
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      child: const CustomText(text: 'Galería', color: Colors.white),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () => imageSelected(ImageSource.camera),
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      child: const CustomText(text: 'Cámara', color: Colors.white),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const CustomText(text: 'Selecciona tu imagen'),
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
        title: const Text('Detalle del despacho'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    text: 'H.Inicio: ${planta?.hourInit ?? ''}',
                    weight: FontWeight.w400),
                CustomText(
                    text: 'H.Final: ${planta?.hourEnd ?? ''}',
                    weight: FontWeight.w400),
              ],
            ),
          ),
          _cardClient('Cliente', planta?.planta ?? ''),
          _cardClient('Despachado por', planta?.razonSocial ?? ''),
          _cardInfo(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(width: .5, color: Colors.black54),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(text: 'Comentarios', weight: FontWeight.w400),
                const SizedBox(height: 5),
                CustomText(
                    text: planta?.comments ?? '', weight: FontWeight.w300),
              ],
            ),
          ),
          planta!.images!.isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomText(text: 'IMAGENES'),
                )
              : const SizedBox(height: 1),
          planta!.images!.isNotEmpty
              ? Column(
                  children: planta!.images!.map((e) => _cardImage(e)).toList(),
                )
              : const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _cardClient(String title, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title),
          const SizedBox(height: 3),
          CustomText(text: text, weight: FontWeight.w300),
        ],
      ),
    );
  }

  Widget _cardInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Column(
        children: [
          _item('Fecha', planta?.createdAt ?? ''),
          const Divider(),
          _item('Total descargado', '${planta?.totalDescarga ?? 0} kg.'),
          const Divider(),
          _item('Batch Recibido', '${planta?.batchRecibido ?? 0}'),
          const Divider(),
          _item('Reporte pesaje', planta?.reportPesaje ?? ''),
          const Divider(),
          _item('Numero placa', planta?.placa ?? ''),
          const Divider(),
          _item('Cuenta WZero', '${planta?.cuentaWzero ?? '0'}'),
          const Divider(),
          _item('Cuenta WSpan', '${planta?.cuentaWspan ?? '0'}'),
          const Divider(),
          _item('Cuenta Wval', '${planta?.cuentaWval ?? '0'}'),
          const Divider(),
          _item('Coeficiente Cal.', '${planta?.coeficienteCal ?? '0'}'),
          const Divider(),
          _item('Matricula', planta?.matricula ?? ''),
          const Divider(),
          _item('Embarcacion', planta?.embarcacion ?? ''),
        ],
      ),
    );
  }

  Widget _item(String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: title, weight: FontWeight.w400, size: 14),
        const SizedBox(height: 5),
        CustomText(text: text, weight: FontWeight.w300, size: 14),
      ],
    );
  }

  Widget _cardImage(String url) {
    return Container(
      // height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: FadeInImage(
        placeholder: const AssetImage('assets/img/jar-loading.gif'),
        image: NetworkImage(url),
      ),
    );
  }
}

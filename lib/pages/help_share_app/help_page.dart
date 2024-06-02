import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/support.dart';
import 'package:flutter_mario_garcia_app/services/support_service.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final SupportService _supportProvider = SupportService();

  Support? support;

  @override
  void initState() {
    super.initState();
    getSupport();
  }

  void getSupport() async {
    support = await _supportProvider.getSupport();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: size > 700 ? 20 : 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: const CustomText(
                    text: 'Pagina de ayuda', size: 16, weight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                margin: const EdgeInsets.all(20),
                child: Image.asset('assets/icon/mario_logo.png'),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Utiliza nuestro canal de whatsapp para chatear con el equipo de soporte técnico y resuelve todas tus dudas.',
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: .5)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size > 700 ? 80 : 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(text: 'Ir al chat'),
                  IconButton(
                      onPressed: () {
                        if (support != null) {
                          launchUrl(Uri.parse(
                              'https://api.whatsapp.com/send?phone=${support!.phone}&text=Podr%C3%ADa%20ayudarme?'));
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Hubo un error al cargar contacto, intente de nuevo.');
                        }
                      },
                      icon: const Icon(FontAwesomeIcons.whatsapp,
                          color: Colors.green, size: 25)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }

  // Widget _buttonShared(BuildContext context, String name) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (support != null) {
  //         launchUrl(Uri.parse(
  //             'https://api.whatsapp.com/send?phone=51${support!.phone}&text=Podr%C3%ADa%20ayudarme?'));
  //       } else {
  //         MySnackbar.show(
  //             context, 'Hubo un error al cargar contacto, intente de nuevo.');
  //       }
  //     },
  //     child: Card(
  //       elevation: 5.0,
  //       shadowColor: Colors.grey,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Container(
  //         width: 150,
  //         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(name, style: const TextStyle(fontSize: 20)),
  //             SizedBox(
  //               width: 40,
  //               height: 50,
  //               child: Image.asset('assets/img/whatsapp.png'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';
import 'package:share/share.dart';

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: const CustomText(
                    text: 'Comparte la App con tus amigos',
                    size: 16,
                    weight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                margin: const EdgeInsets.all(20),
                child: Image.asset('assets/icon/mario_logo.png'),
              ),
              GestureDetector(
                onTap: () {
                  Share.share(
                      'Te recomiendo esta App https://play.google.com/store/apps/details?id=com.paca.flutter_taximoto',
                      subject: 'Descarga app');
                },
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CustomText(text: 'Compartir app'),
                      SizedBox(width: 10),
                      Icon(Icons.share_outlined),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

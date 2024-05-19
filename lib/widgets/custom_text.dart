import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key, required this.text, this.color, this.size, this.weight});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: color ?? Colors.black,
        fontSize: size ?? 16,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/utils/colors.dart';
import 'package:flutter_mario_garcia_app/utils/style.dart';
import 'package:flutter_mario_garcia_app/widgets/custom_text.dart';

class InfoCardSmall extends StatefulWidget {
  const InfoCardSmall(
      {Key? key,
      required this.title,
      required this.value,
      this.isActive = false,
      required this.onTap})
      : super(key: key);

  final String title;
  final String value;

  final bool isActive;
  final VoidCallback onTap;

  @override
  State<InfoCardSmall> createState() => _InfoCardSmallState();
}

class _InfoCardSmallState extends State<InfoCardSmall> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: widget.isActive ? primary : lightGray, width: .5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: widget.title,
                    size: 16,
                    weight: FontWeight.w600,
                    color: lightGray,
                  ),
                  CustomText(
                    text: widget.value,
                    size: 16,
                    weight: FontWeight.w400,
                    color: dark,
                  )
                ],
              ),
              const SizedBox(height: 5),
              widget.isActive
                  ? const CustomText(
                      text: 'Ver más >>',
                      size: 14,
                      weight: FontWeight.w600,
                      color: primary,
                    )
                  : Container(),
            ],
          )),
    );
  }
}

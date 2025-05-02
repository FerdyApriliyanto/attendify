import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigatorButton extends StatelessWidget {
  final String label;

  const NavigatorButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: ColorList.primaryColor,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            label,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeProfileFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const ChangeProfileFieldWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabled: enabled ? true : false,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        ),
      ],
    );
  }
}

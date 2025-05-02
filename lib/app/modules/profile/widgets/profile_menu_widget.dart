import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuWidget extends StatelessWidget {
  final Icon menuIcon;
  final String menuTitle;
  final void Function() onTap;

  const ProfileMenuWidget(
      {super.key,
      required this.menuIcon,
      required this.menuTitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              menuIcon,
              SizedBox(
                width: 8,
              ),
              Text(
                menuTitle,
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
          )
        ],
      ),
    );
  }
}

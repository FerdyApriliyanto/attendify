import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatBubbleWidget extends StatelessWidget {
  final bool isSender;
  final String message;
  final String time;
  final String image;

  const ChatBubbleWidget(
      {super.key,
      required this.isSender,
      required this.message,
      required this.time,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: isSender
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: ColorList.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      padding: EdgeInsetsDirectional.all(12),
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white)),
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    DateFormat.jm().format(DateTime.parse(time)),
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: image == ''
                                ? Image.asset('assets/logo/noimage.png')
                                : Image.network(image)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFf2f3f8),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          padding: EdgeInsetsDirectional.all(12),
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.black)),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    DateFormat.jm().format(DateTime.parse(time)),
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ));
  }
}

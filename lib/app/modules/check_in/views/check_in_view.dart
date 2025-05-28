import 'package:attendify/app/modules/check_in/controllers/check_in_controller.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Check In',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    controller.currentTime.value,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: ColorList.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => Text(
                    controller.currentDate.value,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // CHECK-IN BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarGlow(
                      glowColor: Colors.black,
                      glowRadiusFactor: 0.2,
                      duration: Duration(seconds: 2),
                      glowCount: 1,
                      child: GestureDetector(
                        onTap:
                            controller.isCheckInLoading.value ||
                                    controller.isCheckOutLoading.value
                                ? null
                                : controller.checkInAttendance,
                        child: Obx(
                          () => Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color:
                                  controller.isCheckOutLoading.value
                                      ? Colors.grey
                                      : ColorList.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child:
                                controller.isCheckInLoading.value
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        Text(
                                          'Check In',
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    AvatarGlow(
                      glowColor: Colors.black,
                      glowRadiusFactor: 0.2,
                      duration: Duration(seconds: 2),
                      glowCount: 1,
                      child: GestureDetector(
                        onTap:
                            controller.isCheckInLoading.value ||
                                    controller.isCheckOutLoading.value
                                ? null
                                : controller.checkOutAttendance,
                        child: Obx(
                          () => Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color:
                                  controller.isCheckInLoading.value
                                      ? Colors.grey
                                      : ColorList.dangerColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child:
                                controller.isCheckOutLoading.value
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        Text(
                                          'Check Out',
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

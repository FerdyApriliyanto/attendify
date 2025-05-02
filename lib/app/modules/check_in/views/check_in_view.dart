import 'package:attendify/app/modules/check_in/controllers/check_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.formattedTime()),
              Text(controller.formattedTime(isDay: true)),
              const SizedBox(
                height: 40,
              ),
              AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, child) {
                    double scale =
                        1 + (controller.animationController.value * 0.1);
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                      onTap: controller.checkInAttendace,
                      child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.back_hand_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text('Check In',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ))))
            ],
          ),
        ),
      ),
    );
  }
}

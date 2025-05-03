import 'package:attendify/app/modules/introduction/widgets/navigator_button.dart';
import 'package:attendify/app/routes/app_pages.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Text(
              'Introducing Attendify.',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            bodyWidget: Text(
              "Welcome to Attendify! Our app helps you check in and out effortlessly using real-time location. Say goodbye to manual attendance — stay on time, stay productive!",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            ),
            image: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: Lottie.asset('assets/lottie/login.json'),
              ),
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              'Experience Attendance Excellence',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            bodyWidget: Text(
              "With Attendify, managing your attendance has never been easier. Simply open the app, confirm your location, and you’re good to go. Accurate, reliable, and designed for your daily workflow.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            ),
            image: SizedBox(
              width: 250,
              height: 250,
              child: Center(
                child: Lottie.asset('assets/lottie/intro-1.json'),
              ),
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              'Unleash the Power of Automate',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            bodyWidget: Text(
              "Attendify makes employee attendance fast and seamless. Whether you’re in the office or working remotely, check-ins are just a tap away. Get started now and experience smart attendance tracking!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            ),
            image: ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: Lottie.asset('assets/lottie/intro-2.json'),
                  ),
                ),
              ],
            ),
          )
        ],
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: GoogleFonts.inter(
              textStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        next: NavigatorButton(label: 'Next'),
        done: NavigatorButton(label: 'Done'),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: ColorList.primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}

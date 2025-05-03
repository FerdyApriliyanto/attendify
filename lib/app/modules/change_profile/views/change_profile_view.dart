import 'package:avatar_glow/avatar_glow.dart';
import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/modules/change_profile/widgets/change_profile_field_widget.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authController = Get.find<AuthController>();

  ChangeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.nameController.text =
        authController.currentLoggedInUserModel.value.name!;
    controller.emailController.text =
        authController.currentLoggedInUserModel.value.email!;
    controller.statusController.text =
        authController.currentLoggedInUserModel.value.status!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            AvatarGlow(
              // endRadius: 75,
              glowColor: Colors.black,
              child: Container(
                margin: EdgeInsets.all(16),
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child:
                      authController
                              .currentLoggedInUserModel
                              .value
                              .photoUrl!
                              .isEmpty
                          ? Image.asset(
                            'assets/logo/noimage.png',
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            authController
                                .currentLoggedInUserModel
                                .value
                                .photoUrl!,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ChangeProfileFieldWidget(
              label: 'Name',
              controller: controller.nameController,
            ),
            SizedBox(height: 18),
            ChangeProfileFieldWidget(
              label: 'Email',
              controller: controller.emailController,
              enabled: false,
            ),
            SizedBox(height: 18),
            ChangeProfileFieldWidget(
              label: 'Status',
              controller: controller.statusController,
            ),
            SizedBox(height: 40),
            SizedBox(
              child: ElevatedButton(
                onPressed:
                    () => authController.updateProfile(
                      controller.nameController.text,
                      controller.statusController.text,
                    ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: ColorList.primaryColor,
                ),
                child: Text(
                  'UPDATE',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

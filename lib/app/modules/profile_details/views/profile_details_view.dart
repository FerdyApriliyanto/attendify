import 'package:avatar_glow/avatar_glow.dart';
import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/modules/profile_details/widgets/change_profile_field_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_details_controller.dart';

class ProfileDetailsView extends GetView<ProfileDetailsController> {
  final authController = Get.find<AuthController>();

  ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.nameController.text =
        authController.currentLoggedInUserModel.value.name!;
    controller.emailController.text =
        authController.currentLoggedInUserModel.value.email!;
    controller.positionController.text =
        authController.currentLoggedInUserModel.value.position!;
    controller.statusController.text =
        authController.currentLoggedInUserModel.value.status!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'My Details',
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
              glowColor: Colors.black,
              child: Container(
                margin: EdgeInsets.all(16),
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child:
                      authController.currentLoggedInUserModel.value.photoUrl ==
                              null
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
              enabled: false,
            ),
            SizedBox(height: 18),
            ChangeProfileFieldWidget(
              label: 'Email',
              controller: controller.emailController,
              enabled: false,
            ),
            SizedBox(height: 18),
            ChangeProfileFieldWidget(
              label: 'Position',
              controller: controller.positionController,
              enabled: false,
            ),
            SizedBox(height: 18),
            ChangeProfileFieldWidget(
              label: 'Status',
              controller: controller.statusController,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

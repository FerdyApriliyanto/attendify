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
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          AvatarGlow(
            glowColor: Colors.black,
            glowRadiusFactor: 0.2,
            child: Container(
              margin: EdgeInsets.all(16),
              width: 200,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child:
                        authController
                                    .currentLoggedInUserModel
                                    .value
                                    .photoUrl ==
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
                ],
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
    );
  }
}

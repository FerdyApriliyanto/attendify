import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/modules/profile_details/widgets/change_profile_field_widget.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  final authController = Get.find<AuthController>();

  UpdateStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.statusController.text =
        authController.currentLoggedInUserModel.value.status ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Update Status',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ChangeProfileFieldWidget(
              label: 'Status',
              controller: controller.statusController,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed:
                    () => authController.updateStatus(
                      controller.statusController.text,
                    ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: ColorList.primaryColor,
                  foregroundColor: Colors.white,
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

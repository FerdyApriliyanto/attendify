import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/modules/profile_details/widgets/change_profile_field_widget.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/office_location_controller.dart';

class OfficeLocationView extends GetView<OfficeLocationController> {
  final authController = Get.find<AuthController>();

  OfficeLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Set Office Location',
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
              label: 'Latitude',
              controller: controller.latitudeController,
              enabled: false,
            ),
            SizedBox(height: 24),
            ChangeProfileFieldWidget(
              label: 'Longitude',
              controller: controller.longitudeController,
              enabled: false,
            ),
            SizedBox(height: 34),
            SizedBox(
              width: Get.width,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isSaveButtonLoading.value
                          ? null
                          : () => controller.getCurrentLocation(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: ColorList.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      controller.isGetButtonLoading.value
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            'GET LOCATION DATA',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: Get.width,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.latitudeText.value.isEmpty ||
                              controller.longitudeText.isEmpty ||
                              controller.isGetButtonLoading.value
                          ? null
                          : () => controller.saveOfficeLocationData(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: ColorList.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      controller.isSaveButtonLoading.value
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            'UPDATE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

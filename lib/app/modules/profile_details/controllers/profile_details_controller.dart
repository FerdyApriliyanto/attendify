import 'package:attendify/app/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailsController extends GetxController {
  final authController = Get.find<AuthController>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void onInit() {
    getProfileDetails();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    positionController.dispose();
    statusController.dispose();
    super.onClose();
  }

  void getProfileDetails() {
    nameController.text = authController.currentLoggedInUserModel.value.name!;
    emailController.text = authController.currentLoggedInUserModel.value.email!;
    positionController.text =
        authController.currentLoggedInUserModel.value.position!;
    statusController.text =
        authController.currentLoggedInUserModel.value.status!;
  }
}

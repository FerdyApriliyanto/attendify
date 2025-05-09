import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    positionController.dispose();
    statusController.dispose();
    super.onClose();
  }
}

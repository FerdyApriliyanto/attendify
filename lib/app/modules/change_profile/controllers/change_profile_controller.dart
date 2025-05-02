import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    statusController.dispose();
    super.onClose();
  }
}

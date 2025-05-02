import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  TextEditingController statusController = TextEditingController();

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }
}

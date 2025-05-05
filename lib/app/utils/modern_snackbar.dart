import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModernSnackbar {
  static void showModernSnackbar({
    required String title,
    required String message,
    Color backgroundColor = Colors.blueAccent,
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(16),
      isDismissible: true,
      duration: duration,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: Duration(milliseconds: 500),
      boxShadows: [
        BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8),
      ],
    );
  }
}

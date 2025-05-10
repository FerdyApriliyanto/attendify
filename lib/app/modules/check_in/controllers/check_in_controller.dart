import 'dart:async';

import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:attendify/app/utils/modern_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CheckInController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var logger = Logger(printer: PrettyPrinter());

  final authController = Get.find<AuthController>();

  var isLoading = false.obs;

  var currentTime = ''.obs;
  var currentDate = ''.obs;
  Timer? _timer;

  late AnimationController animationController;

  final double radiusMeter = 100;

  String formattedTime({bool? isDay}) {
    final now = DateTime.now();
    final formattedTime = DateFormat('MMMM d y').format(now);
    final day = DateFormat('EEEE').format(now);

    return isDay == true ? day : formattedTime;
  }

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void onClose() {
    animationController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void checkIn() {
    logger.i("Check-in berhasil");
  }

  void _updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('HH:mm:ss').format(now);
    currentDate.value = DateFormat('EEEE, dd MMMM yyyy').format(now);
  }

  Future<bool> hasCheckedInToday(String displayName, String uid) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc('$displayName - $uid')
            .collection('checkin')
            .doc(today)
            .get();

    return snapshot.exists;
  }

  Future<void> checkInAttendance() async {
    String displayName =
        authController.userCredential?.user?.displayName ?? 'No Name';
    String uid = authController.userCredential?.user?.uid ?? 'No UID';

    if (await hasCheckedInToday(displayName, uid)) {
      ModernSnackbar.showModernSnackbar(
        title: 'Check-In Rejected',
        message: 'You have already checked in today',
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
    } else {
      try {
        // REQUEST LOCATION PERMISSION
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            ModernSnackbar.showModernSnackbar(
              title: 'Location Rejected',
              message: 'Please allow location access to continue',
              backgroundColor: ColorList.dangerColor,
              icon: Icons.error,
            );
            return;
          }
        }

        isLoading.value = true;

        // GETTING CURRENT POSITION
        Position currentPosition = await Geolocator.getCurrentPosition();

        logger.i('LAT: ${currentPosition.latitude}');
        logger.i('LONG: ${currentPosition.longitude}');

        //GETTING OFFICE LOCATION
        DocumentSnapshot officeLoc =
            await FirebaseFirestore.instance
                .collection('office')
                .doc('location')
                .get();

        // COUNT CURRENT LOCATION DISTANCE WITH OFFICE'S LOCATION
        double distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          double.parse(officeLoc['latitude']),
          double.parse(officeLoc['longitude']),
        );

        logger.i('Office LAT: ${officeLoc['latitude']}');
        logger.i('Office LONG: ${officeLoc['longitude']}');

        logger.i('Distance: $distance');

        // CHECK IF USER IS INSIDE OFFICE LOCATION
        if (distance <= radiusMeter) {
          // STORE DATA TO FIREBASE
          final now = DateTime.now();
          final today = DateFormat('yyyy-MM-dd').format(now);
          final time = DateFormat('HH:mm:ss').format(now);

          await FirebaseFirestore.instance
              .collection('attendance')
              .doc('$displayName - $uid')
              .collection('checkin')
              .doc(today)
              .set({
                'name': displayName,
                'time': '$today $time',
                'latitude': currentPosition.latitude,
                'longitude': currentPosition.longitude,
                'status': 'Check In',
                'userId': uid,
              });

          ModernSnackbar.showModernSnackbar(
            title: 'Check-In Accepted',
            message: 'Thank you for submitting your attendance today',
            icon: Icons.check_circle,
          );
        } else {
          ModernSnackbar.showModernSnackbar(
            title: 'Check-In Rejected',
            message: 'You are currently outside office area',
            backgroundColor: ColorList.dangerColor,
            icon: Icons.error,
          );
        }
      } catch (e) {
        ModernSnackbar.showModernSnackbar(
          title: 'Error Occured',
          message: e.toString(),
          backgroundColor: ColorList.dangerColor,
          icon: Icons.error,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}

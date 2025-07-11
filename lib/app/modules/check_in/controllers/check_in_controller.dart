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

  var isCheckInLoading = false.obs;
  var isCheckOutLoading = false.obs;

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

    final now = DateTime.now();

    final allowedCheckInTime = DateTime(now.year, now.month, now.day, 7, 30);
    final lateTime = DateTime(now.year, now.month, now.day, 8, 15);

    final isLate = now.isAfter(lateTime);
    final status = isLate ? 'Telat' : 'Tepat Waktu';

    if (now.isBefore(allowedCheckInTime)) {
      ModernSnackbar.showModernSnackbar(
        title: 'Check-In Rejected',
        message: 'Check-in only allowed after 07:30 AM',
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
      return;
    }

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

        isCheckInLoading.value = true;

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
                'status': status,
                'userId': uid,
              });

          ModernSnackbar.showModernSnackbar(
            title: 'Check-In Accepted',
            message:
                isLate
                    ? 'Your attendance was counted as late'
                    : 'Thank you for submitting your attendance today',
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
        isCheckInLoading.value = false;
      }
    }
  }

  Future<void> checkOutAttendance() async {
    final displayName =
        authController.userCredential?.user?.displayName ?? 'No Name';
    final uid = authController.userCredential?.user?.uid ?? 'No UID';
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // CHECK IF USER HAS ALREADY CHECK-IN
    final checkinDoc =
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc('$displayName - $uid')
            .collection('checkin')
            .doc(today)
            .get();

    if (!checkinDoc.exists) {
      ModernSnackbar.showModernSnackbar(
        title: 'Checkout Rejected',
        message: 'You haven’t checked in today.',
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
      return;
    }

    // CHECK IF USER HAS ALREADY CHECKED-OUT
    final checkoutDoc =
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc('$displayName - $uid')
            .collection('checkout')
            .doc(today)
            .get();

    if (checkoutDoc.exists) {
      ModernSnackbar.showModernSnackbar(
        title: 'Checkout Rejected',
        message: 'You have already checked out today.',
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
      return;
    }

    try {
      isCheckOutLoading.value = true;

      Position currentPosition = await Geolocator.getCurrentPosition();

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

      if (distance <= radiusMeter) {
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc('$displayName - $uid')
            .collection('checkout')
            .doc(today)
            .set({
              'name': displayName,
              'time': time,
              'latitude': currentPosition.latitude,
              'longitude': currentPosition.longitude,
              'userId': uid,
            });

        ModernSnackbar.showModernSnackbar(
          title: 'Checkout Successful',
          message: 'See you again!',
          icon: Icons.check_circle,
        );
      } else {
        ModernSnackbar.showModernSnackbar(
          title: 'Checkout Rejected',
          message: 'You are not in the office area.',
          backgroundColor: ColorList.dangerColor,
          icon: Icons.error,
        );
      }
    } catch (e) {
      ModernSnackbar.showModernSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
    } finally {
      isCheckOutLoading.value = false;
    }
  }
}

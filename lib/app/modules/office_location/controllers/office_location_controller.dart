import 'package:attendify/app/utils/color_list.dart';
import 'package:attendify/app/utils/modern_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class OfficeLocationController extends GetxController {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final latitudeText = ''.obs;
  final longitudeText = ''.obs;

  var isGetButtonLoading = false.obs;
  var isSaveButtonLoading = false.obs;

  @override
  void onInit() {
    latitudeController.addListener(() {
      latitudeText.value = latitudeController.text;
    });
    longitudeController.addListener(() {
      longitudeText.value = longitudeController.text;
    });

    checkIsOfficeLocationAvailable();
    super.onInit();
  }

  @override
  void onClose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  Future<void> checkIsOfficeLocationAvailable() async {
    CollectionReference loc = FirebaseFirestore.instance.collection('office');
    DocumentSnapshot locData = await loc.doc('location').get();

    if (locData.exists) {
      latitudeController.text = locData['latitude'];
      longitudeController.text = locData['longitude'];
    } else {
      latitudeController.text = '';
      longitudeController.text = '';

      ModernSnackbar.showModernSnackbar(
        title: "Office location hasn't been set",
        message: 'Only Admin can set office location',
        backgroundColor: ColorList.dangerColor,
        icon: Icons.warning_amber_outlined,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      // REQUEST LOCATION PERMISSION
      isGetButtonLoading.value = true;

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

      // GETTING CURRENT LOCATION
      Position currentPosition = await Geolocator.getCurrentPosition();

      latitudeController.text = currentPosition.latitude.toString();
      longitudeController.text = currentPosition.longitude.toString();

      ModernSnackbar.showModernSnackbar(
        title: 'Get Location Success',
        message: 'Successfully getting your current location',
        icon: Icons.check,
      );
    } catch (e) {
      ModernSnackbar.showModernSnackbar(
        title: 'Error Occured',
        message: e.toString(),
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
    }

    isGetButtonLoading.value = false;
  }

  Future<void> saveOfficeLocationData() async {
    CollectionReference loc = FirebaseFirestore.instance.collection('office');

    try {
      isSaveButtonLoading.value = true;

      await loc.doc('location').set({
        'latitude': latitudeController.text,
        'longitude': longitudeController.text,
      });

      Get.back();

      ModernSnackbar.showModernSnackbar(
        title: 'Save Location Success',
        message: 'Successfully saved your office location',
        icon: Icons.check,
      );
    } catch (e) {
      ModernSnackbar.showModernSnackbar(
        title: 'Error Occured',
        message: e.toString(),
        backgroundColor: ColorList.dangerColor,
        icon: Icons.error,
      );
    }

    isSaveButtonLoading.value = false;
  }
}

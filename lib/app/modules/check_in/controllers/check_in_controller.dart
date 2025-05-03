import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CheckInController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var logger = Logger(printer: PrettyPrinter());

  late AnimationController animationController;
  // Lokasi kantor (misalnya: latitude dan longitude kantor)
  final double officeLat = -6.200000;
  final double officeLng = 106.816666;
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
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void checkIn() {
    logger.i("Check-in berhasil");
  }

  Future<void> checkInAttendace() async {
    try {
      // 1. Cek permission lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Lokasi Ditolak',
            'Izin lokasi diperlukan untuk absensi',
          );
          return;
        }
      }

      // 2. Dapatkan lokasi sekarang
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Hitung jarak dari kantor
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        officeLat,
        officeLng,
      );

      // 4. Cek apakah dalam radius
      if (distance <= radiusMeter) {
        // 5. Simpan ke Firebase
        final now = DateTime.now();
        final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        await FirebaseFirestore.instance.collection('absensi').add({
          'waktu': time,
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'status': 'Check In',
          'userId': 'user123', // ganti dengan ID user dari auth
        });

        Get.snackbar('Check-In Berhasil', 'Absen telah dicatat');
      } else {
        Get.snackbar('Check-In Gagal', 'Anda berada di luar area kantor');
      }
    } catch (e) {
      Get.snackbar('Terjadi Error', e.toString());
    }
  }
}

import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var index = 0.obs;

  void setIndex(int newIndex) {
    index.value = newIndex;
  }
}

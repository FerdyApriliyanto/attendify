import 'package:attendify/app/modules/office_location/controllers/office_location_controller.dart';
import 'package:get/get.dart';

class OfficeLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficeLocationController>(() => OfficeLocationController());
  }
}

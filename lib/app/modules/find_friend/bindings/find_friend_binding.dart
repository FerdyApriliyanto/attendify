import 'package:get/get.dart';

import '../controllers/find_friend_controller.dart';

class FindFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindFriendController>(
      () => FindFriendController(),
    );
  }
}

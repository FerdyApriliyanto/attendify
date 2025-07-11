import 'package:attendify/app/modules/office_location/bindings/office_location_binding.dart';
import 'package:attendify/app/modules/office_location/views/office_location_view.dart';
import 'package:get/get.dart';

import 'package:attendify/app/modules/bottomNav/bindings/bottom_nav_binding.dart';
import 'package:attendify/app/modules/bottomNav/views/bottom_nav_view.dart';
import 'package:attendify/app/modules/profile_details/bindings/profile_details_binding.dart';
import 'package:attendify/app/modules/profile_details/views/profile_details_view.dart';
import 'package:attendify/app/modules/chat_room/bindings/chat_room_binding.dart';
import 'package:attendify/app/modules/chat_room/views/chat_room_view.dart';
import 'package:attendify/app/modules/find_friend/bindings/find_friend_binding.dart';
import 'package:attendify/app/modules/find_friend/views/find_friend_view.dart';
import 'package:attendify/app/modules/home/bindings/home_binding.dart';
import 'package:attendify/app/modules/home/views/home_view.dart';
import 'package:attendify/app/modules/introduction/bindings/introduction_binding.dart';
import 'package:attendify/app/modules/introduction/views/introduction_view.dart';
import 'package:attendify/app/modules/login/bindings/login_binding.dart';
import 'package:attendify/app/modules/login/views/login_view.dart';
import 'package:attendify/app/modules/profile/bindings/profile_binding.dart';
import 'package:attendify/app/modules/profile/views/profile_view.dart';
import 'package:attendify/app/modules/update_status/bindings/update_status_binding.dart';
import 'package:attendify/app/modules/update_status/views/update_status_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.FIND_FRIEND,
      page: () => FindFriendView(),
      binding: FindFriendBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_STATUS,
      page: () => UpdateStatusView(),
      binding: UpdateStatusBinding(),
    ),
    GetPage(
      name: _Paths.OFFICE_LOCATION,
      page: () => OfficeLocationView(),
      binding: OfficeLocationBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PROFILE,
      page: () => ProfileDetailsView(),
      binding: ProfileDetailsBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV,
      page: () => BottomNavView(),
      binding: BottomNavBinding(),
    ),
  ];
}

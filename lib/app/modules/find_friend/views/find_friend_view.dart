import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../controllers/find_friend_controller.dart';

class FindFriendView extends GetView<FindFriendController> {
  final authController = Get.find<AuthController>();

  FindFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40,
                    child: GestureDetector(
                      onTap: () => Get.offAllNamed(Routes.BOTTOM_NAV),
                      child: Icon((Icons.arrow_back_ios)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.findFriendController,
                      cursorColor: Colors.black,
                      onChanged:
                          (value) => controller.findFriend(
                            value,
                            authController
                                .currentLoggedInUserModel
                                .value
                                .email!,
                          ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        hintText: 'Search for friends to start chatting',
                        hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Obx(
              () =>
                  controller.temp.isEmpty
                      ? Expanded(
                        child: Center(
                          child: Lottie.asset('assets/lottie/not-found.json'),
                        ),
                      )
                      : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.temp.length,
                          itemBuilder: (context, index) {
                            var data = controller.temp[index];
                            return ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 16,
                                right: 28,
                              ),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.black26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child:
                                      data["photoUrl"] == null
                                          ? Image.asset(
                                            'assets/logo/noimage.png',
                                          )
                                          : Image.network(data["photoUrl"]),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${data["name"]}',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${data["email"]}',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap:
                                    () => authController.addNewChat(
                                      data['email'],
                                    ),
                                child: Icon(Icons.messenger_outline_rounded),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

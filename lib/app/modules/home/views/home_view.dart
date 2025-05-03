import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/routes/app_pages.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authController = Get.find<AuthController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.FIND_FRIEND);
                  },
                  icon: Icon(Icons.add, size: 34),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.usersChatStream(
                currentUserEmail:
                    authController.currentLoggedInUserModel.value.email!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var userChatCollection = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: userChatCollection.length,
                    itemBuilder: (context, index) {
                      var data = userChatCollection[index];

                      return StreamBuilder<
                        DocumentSnapshot<Map<String, dynamic>>
                      >(
                        stream: controller.friendsStream(data['connection']),
                        builder: (context, listTileSnapshot) {
                          if (listTileSnapshot.connectionState ==
                              ConnectionState.active) {
                            var dataListTile = listTileSnapshot.data!.data();

                            return ListTile(
                              onTap:
                                  () => controller.openChatRoom(
                                    data.id,
                                    authController
                                        .currentLoggedInUserModel
                                        .value
                                        .email!,
                                    '${data['connection']}',
                                  ),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.black26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    dataListTile!["photoUrl"],
                                  ),
                                ),
                              ),
                              title: Text(
                                '${dataListTile['name']}',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle:
                                  dataListTile['status'] == ''
                                      ? Text('No Status')
                                      : Text(
                                        '${dataListTile["status"]}',
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                              trailing:
                                  data['totalUnread'] == 0
                                      ? Text(
                                        DateFormat.jm().format(DateTime.parse(data['lastTime'])),
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                      : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat.jm().format(DateTime.parse(data['lastTime'])),
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Material(
                                            color: ColorList.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Text(
                                                '${data['totalUnread']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorList.primaryColor,
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorList.primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:attendify/app/auth/auth_controller.dart';
import 'package:attendify/app/modules/chat_room/widgets/chat_bubble_widget.dart';
import 'package:attendify/app/modules/chat_room/widgets/emoji_picker_widget.dart';
import 'package:attendify/app/routes/app_pages.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import '../controllers/chat_room_controller.dart';

// ignore: must_be_immutable
class ChatRoomView extends GetView<ChatRoomController> {
  var logger = Logger(printer: PrettyPrinter());

  final authController = Get.find<AuthController>();
  final String chatId = (Get.arguments as Map<String, dynamic>)['chatId'];

  ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leadingWidth: 80,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => Get.offAllNamed(Routes.BOTTOM_NAV),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 4),
              Icon(Icons.arrow_back),
              SizedBox(width: 4),
              StreamBuilder<DocumentSnapshot<Object?>>(
                stream: controller.receiverChatRoomStream(
                  (Get.arguments as Map<String, dynamic>)['friendEmail'],
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var receiverData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    logger.i(receiverData);
                    return CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            receiverData['photoUrl'] == null
                                ? Image.asset('assets/logo/noimage.png')
                                : Image.network(receiverData['photoUrl']),
                      ),
                    );
                  }
                  return CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/logo/noimage.png'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.receiverChatRoomStream(
            (Get.arguments as Map<String, dynamic>)['friendEmail'],
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var receiverData = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                receiverData['name'],
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text('-', style: TextStyle(fontSize: 12)),
              ],
            );
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isEmojiShown.isTrue) {
            controller.isEmojiShown.value = false;
          } else {
            Navigator.pop(context);
          }

          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatsStream(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var chatsDoc = snapshot.data!.docs;

                    return StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: controller.receiverChatRoomStream(
                        (Get.arguments as Map<String, dynamic>)['friendEmail'],
                      ),
                      builder: (context, snapshot2) {
                        if (snapshot2.connectionState ==
                            ConnectionState.active) {
                          var receiverData =
                              snapshot2.data!.data() as Map<String, dynamic>;
                          Timer(
                            Duration.zero,
                            () => controller.scrollController.jumpTo(
                              controller
                                  .scrollController
                                  .position
                                  .maxScrollExtent,
                            ),
                          );
                          return ListView.builder(
                            controller: controller.scrollController,
                            itemCount: chatsDoc.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text('${chatsDoc[index]['groupTime']}'),
                                    ChatBubbleWidget(
                                      isSender:
                                          chatsDoc[index]['sender'] ==
                                                  authController
                                                      .currentLoggedInUserModel
                                                      .value
                                                      .email
                                              ? true
                                              : false,
                                      message: '${chatsDoc[index]['message']}',
                                      time: '${chatsDoc[index]['time']}',
                                      image:
                                          receiverData['photoUrl'] ??
                                          '',
                                    ),
                                  ],
                                );
                              } else {
                                if (chatsDoc[index]['groupTime'] ==
                                    chatsDoc[index - 1]['groupTime']) {
                                  return ChatBubbleWidget(
                                    isSender:
                                        chatsDoc[index]['sender'] ==
                                                authController
                                                    .currentLoggedInUserModel
                                                    .value
                                                    .email
                                            ? true
                                            : false,
                                    message: '${chatsDoc[index]['message']}',
                                    time: '${chatsDoc[index]['time']}',
                                    image:
                                        receiverData['photoUrl'] ??
                                        '',
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text('${chatsDoc[index]['groupTime']}'),
                                      ChatBubbleWidget(
                                        isSender:
                                            chatsDoc[index]['sender'] ==
                                                    authController
                                                        .currentLoggedInUserModel
                                                        .value
                                                        .email
                                                ? true
                                                : false,
                                        message:
                                            '${chatsDoc[index]['message']}',
                                        time: '${chatsDoc[index]['time']}',
                                        image:
                                            receiverData['photoUrl'] ??
                                            '',
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorList.primaryColor,
                          ),
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
            Container(
              margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                controller: controller.chatController,
                focusNode: controller.focusNode,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      controller.focusNode.unfocus();
                      controller.isEmojiShown.toggle();
                    },
                    icon: Obx(
                      () => Icon(
                        Icons.emoji_emotions_outlined,
                        color:
                            controller.isEmojiShown.isTrue
                                ? ColorList.primaryColor
                                : Colors.grey,
                      ),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      color: ColorList.primaryColor,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap:
                            () => controller.sendChat(
                              authController
                                  .currentLoggedInUserModel
                                  .value
                                  .email!,
                              Get.arguments as Map<String, dynamic>,
                              controller.chatController.text,
                            ),
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.send,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            EmojiPickerWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}

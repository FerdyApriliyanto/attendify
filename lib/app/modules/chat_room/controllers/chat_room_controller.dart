import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isEmojiShown = false.obs;
  int totalUnread = 0;

  FocusNode focusNode = FocusNode();

  TextEditingController chatController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String chatId) {
    CollectionReference chats = firestore.collection('chats');

    return chats.doc(chatId).collection('chat').orderBy('time').snapshots();
  }

  Stream<DocumentSnapshot<Object?>> receiverChatRoomStream(
      String receiverEmail) {
    CollectionReference users = firestore.collection('users');

    return users.doc(receiverEmail).snapshots();
  }

  void sendChat(String currentUserEmail, Map<String, dynamic> argument,
      String message) async {
    if (chatController.text != '') {
      String time = DateTime.now().toIso8601String();

      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');

      await chats.doc(argument['chatId']).collection('chat').add({
        'sender': currentUserEmail,
        'receiver': argument['friendEmail'],
        'message': message,
        'time': time,
        'isRead': false,
        'groupTime': DateFormat.yMMMMd('en-US').format(DateTime.now())
      });

      Timer(
          Duration.zero,
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));

      chatController.clear();

      await users
          .doc(currentUserEmail)
          .collection('chats')
          .doc(argument['chatId'])
          .update({'lastTime': time});

      // ADDING CHATS DATA TO RECEIVER/FRIEND COLLECTION
      final checkChatsFriend = await users
          .doc(argument['friendEmail'])
          .collection('chats')
          .doc(argument['chatId'])
          .get();

      totalUnread += 1; // FRIEND/RECEIVER UNREAD

      if (checkChatsFriend.exists) {
        final checkTotalUnread = await chats
            .doc(argument['chatId'])
            .collection('chat')
            .where('isRead', isEqualTo: false)
            .where('sender', isEqualTo: currentUserEmail)
            .get();

        totalUnread = checkTotalUnread.docs.length; // TOTAL UNREAD FRIEND

        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chatId'])
            .update({'lastTime': time, 'totalUnread': totalUnread});
      } else {
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chatId'])
            .set({
          'connection': currentUserEmail,
          'lastTime': time,
          'totalUnread': 1
        });
      }
      // END
    }
  }

  @override
  void onInit() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiShown.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

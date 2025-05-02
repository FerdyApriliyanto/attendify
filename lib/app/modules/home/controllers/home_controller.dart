import 'package:attendify/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> usersChatStream(
      {required String currentUserEmail}) {
    return firestore
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendsStream(
      String friendEmail) {
    return firestore.collection('users').doc(friendEmail).snapshots();
  }

  void openChatRoom(
      String chatId, String currentUserEmail, String friendEmail) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final readStatus = await chats
        .doc(chatId)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('receiver', isEqualTo: currentUserEmail)
        .get();

    readStatus.docs.forEach((element) async {
      await chats
          .doc(chatId)
          .collection('chat')
          .doc(element.id)
          .update({'isRead': true});
    });

    await users
        .doc(currentUserEmail)
        .collection('chats')
        .doc(chatId)
        .update({'totalUnread': 0});

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {'chatId': chatId, 'friendEmail': friendEmail},
    );
  }
}

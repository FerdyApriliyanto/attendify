import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FindFriendController extends GetxController {
  var logger = Logger(printer: PrettyPrinter());

  TextEditingController findFriendController = TextEditingController();

  var query = [].obs;
  var temp = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void findFriend(String name, String email) async {
    if (name.isEmpty) {
      query.value = [];
      temp.value = [];
    } else {
      var keyName = name[0].toUpperCase();
      var findName = keyName + name.substring(1);
      logger.i(findName);

      if (query.isEmpty && name.length == 1) {
        CollectionReference users = firestore.collection('users');

        final queryResult =
            await users
                .where('keyName', isEqualTo: keyName)
                .where('email', isNotEqualTo: email)
                .get();
        final queryLength = queryResult.docs.length;

        if (queryLength > 0) {
          for (int i = 0; i < queryLength; i++) {
            query.add(queryResult.docs[i].data() as Map<String, dynamic>);
          }

          logger.i('JUMLAH DATA : $queryLength');
          logger.i('DATA : $query');
        } else {
          logger.i('JUMLAH DATA : $queryLength');
          logger.i('TIDAK ADA DATA');
        }
      }

      if (query.isNotEmpty) {
        temp.value = [];
        for (var element in query) {
          if (element['name'].startsWith(findName)) {
            temp.add(element);
          }
        }
      }
    }

    query.refresh();
    temp.refresh();
  }

  @override
  void dispose() {
    findFriendController.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindFriendController extends GetxController {
  TextEditingController findFriendController = TextEditingController();

  var query = [].obs;
  var temp = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void findFriend(String name, String email) async {
    if (name.length == 0) {
      query.value = [];
      temp.value = [];
    } else {
      var keyName = name[0].toUpperCase();
      var findName = keyName + name.substring(1);
      print(findName);

      if (query.length == 0 && name.length == 1) {
        CollectionReference users = await firestore.collection('users');

        final queryResult = await users
            .where('keyName', isEqualTo: keyName)
            .where('email', isNotEqualTo: email)
            .get();
        final queryLength = queryResult.docs.length;

        if (queryLength > 0) {
          for (int i = 0; i < queryLength; i++) {
            query.add(queryResult.docs[i].data() as Map<String, dynamic>);
          }

          print('JUMLAH DATA : $queryLength');
          print('DATA : $query');
        } else {
          print('JUMLAH DATA : $queryLength');
          print('TIDAK ADA DATA');
        }
      }

      if (query.length != 0) {
        temp.value = [];
        query.forEach((element) {
          if (element['name'].startsWith(findName)) {
            temp.add(element);
          }
        });
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

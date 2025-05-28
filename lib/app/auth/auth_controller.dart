import 'dart:io';

import 'package:attendify/app/data/models/user_model.dart';
import 'package:attendify/app/routes/app_pages.dart';
import 'package:attendify/app/utils/color_list.dart';
import 'package:attendify/app/utils/loading_popup.dart';
import 'package:attendify/app/utils/modern_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthController extends GetxController {
  var logger = Logger(printer: PrettyPrinter());

  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var currentLoggedInUserModel = UserModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // AUTH
  Future<bool> _skipLogin() async {
    try {
      final status = await _googleSignIn.isSignedIn();

      if (status) {
        await _googleSignIn.signInSilently().then(
          (value) => _currentUser = value,
        );

        final userAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: userAuth.idToken,
          accessToken: userAuth.accessToken,
        );
        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        // UPDATE DATA TO FIRESTORE
        CollectionReference users = firestore.collection('users');
        await users.doc(_currentUser!.email).update({
          'lastSignInTime':
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });
        // END

        // GETTING & PUTTING CURRENT USER LOGGED IN DATA TO LOCAL MODEL
        final currentUser = await users.doc(_currentUser!.email).get();
        final currentUserData = currentUser.data() as Map<String, dynamic>;

        currentLoggedInUserModel(UserModel.fromJson(currentUserData));
        currentLoggedInUserModel.refresh();

        final listChat =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> listChatUser = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;

            listChatUser.add(
              ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['totalUnread'],
              ),
            );
          }
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = listChatUser;
          });
        } else {
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = [];
          });
        }
        // END
        currentLoggedInUserModel.refresh();
        return true;
      }
      return false;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  bool _skipIntroduction() {
    final box = GetStorage();
    if (box.read('status') != null || box.read('status') == true) {
      return true;
    }
    return false;
  }

  Future<void> checkLogin() async {
    if (_skipIntroduction()) {
      isSkipIntro.value = true;
    }

    await _skipLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    } else {
      return 'unknown';
    }
  }

  Future<void> insertDataToLocalModel() async {
    CollectionReference users = firestore.collection('users');

    final currentUser = await users.doc(_currentUser!.email).get();
    final currentUserData = currentUser.data() as Map<String, dynamic>;

    currentLoggedInUserModel(UserModel.fromJson(currentUserData));
    currentLoggedInUserModel.refresh();

    final listChat =
        await users.doc(_currentUser!.email).collection('chats').get();

    if (listChat.docs.isNotEmpty) {
      List<ChatUser> listChatUser = [];
      for (var element in listChat.docs) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        listChatUser.add(
          ChatUser(
            chatId: dataDocChatId,
            connection: dataDocChat['connection'],
            lastTime: dataDocChat['lastTime'],
            totalUnread: dataDocChat['totalUnread'],
          ),
        );
      }
      currentLoggedInUserModel.update((currentLoggedInUserModel) {
        currentLoggedInUserModel!.chats = listChatUser;
      });
    } else {
      currentLoggedInUserModel.update((currentLoggedInUserModel) {
        currentLoggedInUserModel!.chats = [];
      });
    }
    currentLoggedInUserModel.refresh();
  }

  Future<void> login() async {
    final String currentDeviceId = await getDeviceId();

    try {
      LoadingPopup.showLoadingPopup();

      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignedIn = await _googleSignIn.isSignedIn();

      if (isSignedIn) {
        CollectionReference users = firestore.collection('users');

        logger.i('Login Berhasil');
        logger.i(_currentUser);

        final userAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: userAuth.idToken,
          accessToken: userAuth.accessToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        logger.i(userCredential);

        // INSERT STATUS TO LOCAL STORAGE
        final box = GetStorage();
        if (box.read('status') != null) {
          box.remove('status');
        }
        box.write('status', true);
        // END

        // INSERT DATA TO FIRESTORE
        final isNewUser = await users.doc(_currentUser!.email).get();

        if (isNewUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'keyName': _currentUser!.displayName![0].toUpperCase(),
            'email': _currentUser!.email,
            'position':
                _currentUser!.email == '212310012@student.ibik.ac.id'
                    ? 'Admin'
                    : 'Employee',
            'photoUrl': _currentUser!.photoUrl,
            'status': '',
            'deviceId': currentDeviceId,
            'creationTime':
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            'lastSignInTime':
                userCredential!.user!.metadata.lastSignInTime!
                    .toIso8601String(),
            'updatedTime': DateTime.now().toIso8601String(),
          });

          insertDataToLocalModel();
          isAuth.value = true;

          Get.offAllNamed(Routes.BOTTOM_NAV);
        } else {
          final storedDeviceId =
              await firestore
                  .collection('users')
                  .doc(_currentUser!.email)
                  .get();
          final registeredDeviceId = storedDeviceId.data()?['deviceId'];

          if (registeredDeviceId != currentDeviceId) {
            LoadingPopup.hideLoadingPopup();
            await _googleSignIn.signOut();
            isAuth.value = false;

            ModernSnackbar.showModernSnackbar(
              title: 'Access Denied',
              message: 'This account is only allowed on the original device.',
              backgroundColor: ColorList.dangerColor,
              icon: Icons.warning,
            );

            return;
          } else {
            insertDataToLocalModel();
            isAuth.value = true;
            
            Get.offAllNamed(Routes.BOTTOM_NAV);
          }

          await users.doc(_currentUser!.email).update({
            'lastSignInTime':
                userCredential!.user!.metadata.lastSignInTime!
                    .toIso8601String(),
          });
        }
        // END
      } else {
        logger.e('Login Tidak Berhasil');
      }
    } catch (error) {
      logger.e(error);
    } finally {
      LoadingPopup.hideLoadingPopup();
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    Get.offAllNamed(Routes.LOGIN);
  }
  // END

  // PROFILE
  Future<void> updateStatus(String status) async {
    String updatedTime = DateTime.now().toIso8601String();

    CollectionReference users = firestore.collection('users');

    await users.doc(_currentUser!.email).update({
      'status': status,
      'updatedTime': updatedTime,
    });

    currentLoggedInUserModel.update((currentLoggedInUserModel) {
      currentLoggedInUserModel!.status = status;
    });

    currentLoggedInUserModel.refresh();
    Get.back();
  }
  // END

  // FIND FRIEND
  void addNewChat(String friendEmail) async {
    // ignore: prefer_typing_uninitialized_variables
    var chatId;
    bool isNewConnection = false;

    final String lastTime = DateTime.now().toIso8601String();

    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final docChat =
        await users.doc(_currentUser!.email).collection('chats').get();

    if (docChat.docs.isNotEmpty) {
      final checkConnection =
          await users
              .doc(_currentUser!.email)
              .collection('chats')
              .where('connection', isEqualTo: friendEmail)
              .get();

      if (checkConnection.docs.isNotEmpty) {
        isNewConnection = false;
        chatId = checkConnection.docs[0].id;
      } else {
        isNewConnection = true;
      }
    } else {
      isNewConnection = true;
    }

    if (isNewConnection) {
      // CHECK FROM CHATS COLLECTION
      final chatsDocs =
          await chats
              .where(
                'connections',
                whereIn: [
                  [_currentUser!.email, friendEmail],
                  [friendEmail, _currentUser!.email],
                ],
              )
              .get();

      if (chatsDocs.docs.isNotEmpty) {
        chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection('chats')
            .doc(chatsDocs.docs[0].id)
            .set({
              'connection': friendEmail,
              'lastTime': lastTime,
              'totalUnread': 0,
            });

        final listChat =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> listChatUser = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            listChatUser.add(
              ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['totalUnread'],
              ),
            );
          }
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = listChatUser;
          });
        } else {
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = [];
          });
        }

        chatId = chatsDocs.docs[0].id;
        currentLoggedInUserModel.refresh();
      } else {
        final newChatDoc = await chats.add({
          'connections': [_currentUser!.email, friendEmail],
        });

        chats.doc(newChatDoc.id).collection('chat');

        await users
            .doc(_currentUser!.email)
            .collection('chats')
            .doc(newChatDoc.id)
            .set({
              'connection': friendEmail,
              'lastTime': lastTime,
              'totalUnread': 0,
            });

        final listChat =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> listChatUser = [];
          for (var element in listChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;

            listChatUser.add(
              ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['totalUnread'],
              ),
            );
          }
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = listChatUser;
          });
        } else {
          currentLoggedInUserModel.update((currentLoggedInUserModel) {
            currentLoggedInUserModel!.chats = [];
          });
        }

        chatId = newChatDoc.id;
        currentLoggedInUserModel.refresh();
      }
      // END
    }
    logger.i(chatId);

    final readStatus =
        await chats
            .doc(chatId)
            .collection('chat')
            .where('isRead', isEqualTo: false)
            .where('receiver', isEqualTo: _currentUser!.email)
            .get();

    // ignore: avoid_function_literals_in_foreach_calls
    readStatus.docs.forEach((element) async {
      await chats.doc(chatId).collection('chat').doc(element.id).update({
        'isRead': true,
      });
    });

    await users.doc(_currentUser!.email).collection('chats').doc(chatId).update(
      {'totalUnread': 0},
    );

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {'chatId': '$chatId', 'friendEmail': friendEmail},
    );
  }
}

import 'package:attendify/app/modules/chat_room/controllers/chat_room_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiPickerWidget extends StatelessWidget {
  final ChatRoomController controller;

  const EmojiPickerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isEmojiShown.isTrue
        ? SizedBox(
            height: 300,
            child: EmojiPicker(
              onEmojiSelected: (Category? category, Emoji emoji) {},
              onBackspacePressed: () {},
              textEditingController: controller.chatController,
              config: Config(
                // columns: 7,
                // emojiSizeMax: 32 *
                //     (foundation.defaultTargetPlatform == TargetPlatform.iOS
                //         ? 1.30
                //         : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                // verticalSpacing: 0,
                // horizontalSpacing: 0,
                // gridPadding: EdgeInsets.zero,
                // initCategory: Category.RECENT,
                // bgColor: Color(0xFFF2F2F2),
                // indicatorColor: ColorList.primaryColor,
                // iconColor: Colors.grey,
                // iconColorSelected: ColorList.primaryColor,
                // backspaceColor: ColorList.primaryColor,
                // skinToneDialogBgColor: Colors.white,
                // skinToneIndicatorColor: Colors.grey,
                // enableSkinTones: true,
                // recentTabBehavior: RecentTabBehavior.RECENT,
                // recentsLimit: 28,
                // noRecents: const Text(
                //   'No Recents',
                //   style: TextStyle(fontSize: 20, color: Colors.black26),
                //   textAlign: TextAlign.center,
                // ), // Needs to be const Widget
                // loadingIndicator:
                //     const SizedBox.shrink(), // Needs to be const Widget
                // tabIndicatorAnimDuration: kTabScrollDuration,
                // categoryIcons: const CategoryIcons(),
                // buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          )
        : SizedBox());
  }
}

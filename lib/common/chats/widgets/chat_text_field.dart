import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/chats/controller/chats_contoller.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/utils/colors.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({required this.receiverId, super.key});
  final String receiverId;

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  TextEditingController messageEditingController = TextEditingController();
  bool messageIconEnable = false;
  void sendTextMessage() async {
    if (messageIconEnable) {
      ref.read(chatControllerProvider).sendTextMessage(
          context: context,
          textMessage: messageEditingController.text,
          receiverId: widget.receiverId);
      messageEditingController.clear();
    }
  }

  @override
  void initState() {
    messageEditingController = TextEditingController();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          maxLines: 4,
          minLines: 1,
          autofocus: true,
          controller: messageEditingController,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                messageIconEnable = false;
              });
            } else {
              setState(() {
                messageIconEnable = true;
              });
            }
          },
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Coloors.greyDark,
              ),
              hintText: 'Message',
              hintStyle: TextStyle(
                color: context.theme.greyColor,
              ),
              filled: true,
              fillColor: context.theme.chatTextFieldBg,
              isDense: true,
              border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(style: BorderStyle.none, width: 0),
                  borderRadius: BorderRadius.circular(30)),
              suffixIcon: const Icon(
                Icons.camera_alt_outlined,
                color: Coloors.greyDark,
              )),
        )),
        IconButton(
            onPressed: () => sendTextMessage(),
            icon: Icon(
              messageIconEnable ? Icons.send_outlined : Icons.mic_none_outlined,
              color: Coloors.greenDark,
            ))
      ],
    );
  }
}

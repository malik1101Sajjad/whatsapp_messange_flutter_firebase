import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/helper/show_alert_dialog.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_me/feature/auth/widgets/custom_text_field.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/custom_elevated_button.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  File? _image;

  late TextEditingController usernameController;
  saveUserDataToFirebase() {
    String userName = usernameController.text;
    if (userName.isEmpty) {
      return showAlertDilog(
          context: context, message: 'please enter user name');
    } else if (userName.length < 3 || userName.length > 20) {
      return showAlertDilog(
          context: context,
          message: 'A username length should be between 3-20');
    } else {
      return ref.read(authControllerProvide).saveUserInfoToFirestore(
          username: userName,
          profileImage: _image ?? '',
          context: context,
          mounted: mounted);
    }
  }

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile info',
          style: TextStyle(color: context.theme.authAppbarTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Please provide your name and an optional profile photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.theme.greyColor,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => imagePickerTypeBottomSheet(),
                child: Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.photoIconBgColor,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!), fit: BoxFit.cover)
                          : null),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3, right: 3),
                    child: Icon(
                      _image == null ? Icons.add_a_photo_rounded : null,
                      size: 48,
                      color: context.theme.photoIconColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      controller: usernameController,
                      hintText: 'Type your name here',
                      textAlign: TextAlign.start,
                      autoFocus: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: context.theme.photoIconColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: () => saveUserDataToFirebase(),
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }

  void getimage({required ImageSource source}) async {
    final image = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = File(image!.path);
    });
  }

  imagePickerTypeBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                const Text(
                  'Profile photo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(width: 15),
              ],
            ),
            Divider(
              color: context.theme.greyColor!.withOpacity(.3),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imagePickerIcon(
                    onTap: () {
                      getimage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    icon: Icons.photo_camera_back_rounded,
                    text: 'Gallary'),
                const SizedBox(width: 30),
                imagePickerIcon(
                    onTap: () {
                      getimage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    icon: Icons.camera_alt_rounded,
                    text: 'Camera'),
              ],
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  imagePickerIcon({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
          color: Coloors.greenDark,
          iconSize: 70,
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: context.theme.greyColor,
          ),
        ),
      ],
    );
  }
}

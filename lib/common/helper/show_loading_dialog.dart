import 'package:flutter/material.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';

import '../utils/colors.dart';

showLoadingDialog({
  required BuildContext context,
  required String message,
}) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircularProgressIndicator(
                    color: Coloors.greenDark,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text(
                    message,
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: context.theme.greyColor),
                  ))
                ],
              )
            ],
          ),
        );
      });
}

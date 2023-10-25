import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/helper/show_alert_dialog.dart';
import 'package:whatsapp_me/common/utils/colors.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_me/feature/auth/widgets/custom_text_field.dart';

import '../../../common/widgets/custom_elevated_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;
  sendCodeToPhone() {
    final phoneNumber = phoneNumberController.text;
    final countryName = countryNameController.text;
    //final countryCode = countryCodeController.text;
    if (phoneNumber.isEmpty) {
      return showAlertDilog(
          context: context, message: 'Please enter your phone number');
    } else if (phoneNumber.length < 10) {
      return showAlertDilog(
        context: context,
        message:
            'The phone number you entered is too short for the country: $countryName\n\nInclude your area code if you haven\'t',
      );
    } else if (phoneNumber.length > 11) {
      return showAlertDilog(
        context: context,
        message:
            "The phone number you entered is too long for the country: $countryName",
      );
    } else {
      return ref
          .read(authControllerProvide)
          .sendSmsCode(context: context, phoneNumber: "+92$phoneNumber");
    }
  }
  showCountryCodePicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: ['Pk'],
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
        backgroundColor: Theme.of(context).backgroundColor,
        flagSize: 22,
        textStyle: TextStyle(color: context.theme.greyColor),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        inputDecoration: InputDecoration(
            labelStyle: TextStyle(color: context.theme.greyColor),
            prefixIcon: const Icon(Icons.language, color: Coloors.greenDark),
            hintText: 'Search Country code or name',
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: context.theme.greyColor!.withOpacity(0.2)),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Coloors.greenDark))),
      ),
      onSelect: (county) {
        countryNameController.text = county.name;
        countryCodeController.text = county.countryCode;
      },
    );
  }

  @override
  void initState() {
    countryNameController = TextEditingController(text: 'Pakistan');
    countryCodeController = TextEditingController(text: '92');
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    countryNameController.dispose();
    countryCodeController.dispose();
    phoneNumberController.dispose();
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
          'Enter your phone number',
          style: TextStyle(color: context.theme.authAppbarTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: context.theme.greyColor,
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'WhatsApp will need to verify your number. ',
                      style: TextStyle(
                        color: context.theme.greyColor,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: "What's my number?",
                          style: TextStyle(
                            color: context.theme.blueColor,
                          ),
                        )
                      ])),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: CustomTextField(
                onTap: () => showCountryCodePicker(),
                controller: countryNameController,
                readOnly: true,
                suffixIcon: const Icon(Icons.arrow_drop_down,
                    color: Coloors.greenLight, size: 22),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: CustomTextField(
                      onTap: () {},
                      controller: countryCodeController,
                      prefixText: '+',
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: phoneNumberController,
                      hintText: 'phone number',
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Carrier charges may apply',
              style: TextStyle(
                color: context.theme.greyColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: () => sendCodeToPhone(),
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/routs/routs.dart';
import 'package:whatsapp_me/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_me/feature/auth/pages/login_page.dart';
import 'package:whatsapp_me/feature/welcome/widgets/language_button.dart';
import 'package:whatsapp_me/feature/welcome/widgets/privicy_and_terms.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Image.asset(
                  'assets/images/circle.png',
                  height: MediaQuery.of(context).size.height * 0.33,
                  color: context.theme.circleImageColor,
                )),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Welcome to WhatsApp',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const PrivacyAndTerms(),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(NavigationPage(child:const LoginPage()));
                      },
                      text: 'AGREE AND CONTINUE'),
                  const SizedBox(height: 30),
                  const LanguageButton(),
                  const SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

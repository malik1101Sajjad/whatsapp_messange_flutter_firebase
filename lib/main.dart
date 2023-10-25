import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/theme/dark_theme.dart';
import 'package:whatsapp_me/common/theme/light_theme.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_me/feature/welcome/pages/welcome_page.dart';

import 'feature/home/pages/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'WhatsApp Me',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: ThemeMode.system,
        home: ref.watch(userAuthInfoProvider).when(data: (user) {
          FlutterNativeSplash.remove();
          if (user == null) return const WelcomePage();
          return const HomePage();
        }, error: (error, stackTrace) {
          return const Scaffold(
              body: Center(child: Text('Something  Wroing happend!')));
        }, loading: () {
          return const SizedBox();
        }));
  }
}

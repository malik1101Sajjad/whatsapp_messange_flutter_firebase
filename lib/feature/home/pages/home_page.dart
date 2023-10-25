import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_me/feature/home/pages/call_home_page.dart';
import 'package:whatsapp_me/feature/home/pages/chat_home_page.dart';
import 'package:whatsapp_me/feature/home/pages/status_home_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  late Timer _timer;
  void userPresent() {
    ref.read(authControllerProvide).updateUserPresence();
  }

  @override
  void initState() {
    userPresent();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateStatus(status: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      updateStatus(status: false);
    } else if (state == AppLifecycleState.resumed) {
      updateStatus(status: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  void updateStatus({required bool status}) {
    ref.read(authControllerProvide).updatefireStoreData(status: status);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'WhatsApp',
            style: TextStyle(letterSpacing: 1),
          ),
          elevation: 1,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: const TabBar(
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: const TabBarView(
            children: [ChatHomePage(), StatusHomePage(), CallHomePage()]),
      ),
    );
  }
}

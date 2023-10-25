import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/helper/show_alert_dialog.dart';
import 'package:whatsapp_me/common/helper/show_loading_dialog.dart';
import 'package:whatsapp_me/common/models/user_model.dart';
import 'package:whatsapp_me/common/repositary/firebase_storage_repository.dart';
import 'package:whatsapp_me/common/routs/routs.dart';
import 'package:whatsapp_me/feature/auth/pages/user_info_page.dart';
import 'package:whatsapp_me/feature/auth/pages/verification_page.dart';

import '../../home/pages/home_page.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance,
      firestorage: FirebaseFirestore.instance,
      reailtime: FirebaseDatabase.instance);
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestorage;
  final FirebaseDatabase reailtime;
  AuthRepository(
      {required this.auth, required this.firestorage, required this.reailtime});

  void updatefireStoreData({required bool status}) {
    firestorage.collection('users').doc(auth.currentUser?.uid).update(
        {"active": status, "lastSeen": DateTime.now().millisecondsSinceEpoch});
  }

  Stream<UserModel> getUserPresenceStatus({required String uid}) {
    return firestorage
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void updateUserPresence() {
    Map<String, dynamic> online = {
      'active': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    Map<String, dynamic> offline = {
      'active': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    final connectedRef = reailtime.ref('connected');
    reailtime.ref().child(auth.currentUser!.uid).update(online);
    connectedRef.onValue.listen((event) async {
      final isConnected = event.snapshot.value as bool? ?? false;
      if (isConnected) {
        // await reailtime.ref().child(auth.currentUser!.uid).update(online);
      } else {
        await reailtime
            .ref()
            .child(auth.currentUser!.uid)
            .onDisconnect()
            .update(offline);
      }
    });
  }

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user;
    final userInfo =
        await firestorage.collection('users').doc(auth.currentUser?.uid).get();
    if (userInfo.data() == null) return user;
    user = UserModel.fromMap(userInfo.data()!);
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(context: context, message: "Saving user info ...");
      String uid = auth.currentUser!.uid;
      String profileImageUrl = '';
      if (profileImage != null) {
        profileImageUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .strogeFileToFirebase('profileImage/$uid', profileImage);
        UserModel user = UserModel(
            username: username,
            uid: uid,
            profileImageUrl: profileImageUrl,
            active: true,
            lastSeen: DateTime.now().millisecondsSinceEpoch,
            phoneNumber: auth.currentUser!.phoneNumber!,
            groupId: []);
        await firestorage.collection('users').doc(uid).set(user.toMap());
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            NavigationPage(child: const HomePage()), (route) => false);
      }
    } catch (e) {
      Navigator.pop(context);
      showAlertDilog(context: context, message: e.toString());
    }
  }

  void verifySmsCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(context: context, message: "'Verifiying code ... ");
      final credential = PhoneAuthProvider.credential(
        verificationId: smsCodeId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential).then((value) =>
          Navigator.of(context).pushAndRemoveUntil(
              NavigationPage(child: const UserInfoPage()), (route) => false));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context);
      showAlertDilog(context: context, message: e.toString());
    }
  }

  void sendSmsCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      showLoadingDialog(
          context: context,
          message: "Sending a verification code to $phoneNumber");
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          showAlertDilog(context: context, message: error.toString());
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context).pushAndRemoveUntil(
              NavigationPage(
                  child: VerificationPage(
                smsCodeId: verificationId,
                phoneNumber: phoneNumber,
              )),
              (route) => false);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context);
      showAlertDilog(context: context, message: e.toString());
    }
  }
}

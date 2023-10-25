import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/models/user_model.dart';

import '../repositary/auth_repository.dart';

final authControllerProvide = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthContoller(authRepository: authRepository, ref: ref);
});
final userAuthInfoProvider = FutureProvider((ref) {
  final authController = ref.read(authControllerProvide).getCurrentUserInfo();
  return authController;
});

class AuthContoller {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthContoller({required this.authRepository, required this.ref});

  void updatefireStoreData({required bool status}) {
    return authRepository.updatefireStoreData(status: status);
  }

  Stream<UserModel> getUserPresenceStatus({required String uid}) {
    return authRepository.getUserPresenceStatus(uid: uid);
  }

  void updateUserPresence() {
    return authRepository.updateUserPresence();
  }

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user = await authRepository.getCurrentUserInfo();
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required BuildContext context,
    required bool mounted,
  }) {
    authRepository.saveUserInfoToFirestore(
        username: username,
        profileImage: profileImage,
        ref: ref,
        context: context,
        mounted: mounted);
  }

  void verifySmsCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }) {
    authRepository.verifySmsCode(
        context: context,
        smsCodeId: smsCodeId,
        smsCode: smsCode,
        mounted: mounted);
  }

  void sendSmsCode({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.sendSmsCode(context: context, phoneNumber: phoneNumber);
  }
}

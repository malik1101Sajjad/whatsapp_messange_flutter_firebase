import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/contact/repository/contacts_repository.dart';

final contactsControllerProvider = FutureProvider((ref) {
  final contactRepository = ref.watch(contactsRepositoryProvider);
  return contactRepository.getContacAll();
});

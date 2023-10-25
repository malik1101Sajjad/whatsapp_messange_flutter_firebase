import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_me/common/chats/pages/chats_pages.dart';
import 'package:whatsapp_me/common/contact/controller/contacts_controller.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/models/user_model.dart';
import 'package:whatsapp_me/common/routs/routs.dart';

import '../../utils/colors.dart';
import '../widgets/contact_card.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});
  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! it's a fast, simple, and secure app we can call each other for free. Get it at https://whatsapp.com/dl/",
    );
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Selects Contacts',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 3),
          ref.watch(contactsControllerProvider).when(
            data: (allContacts) {
              return Text(
                "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'}",
                style: const TextStyle(fontSize: 12),
              );
            },
            error: (error, stackTrace) {
              return const SizedBox();
            },
            loading: () {
              return const Text(
                'counting...',
                style: TextStyle(fontSize: 12),
              );
            },
          )
        ]),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(contactsControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              late UserModel firebaseContact;
              late UserModel phoneContacts;
              if (index < allContacts[0].length) {
                firebaseContact = allContacts[0][index];
                debugPrint("firebase contacts : $firebaseContact");
              } else if (index <
                  allContacts[0].length + allContacts[1].length) {
                phoneContacts = allContacts[1][index - allContacts[0].length];
                debugPrint("Phone contacts : $phoneContacts");
              }
              debugPrint("invalid inder :$index");
              return index < allContacts[0].length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myListTile(
                                  leading: Icons.group, text: 'New Grop'),
                              myListTile(
                                leading: Icons.contacts,
                                text: 'New contact',
                                trailing: Icons.qr_code,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Contacts on WhatsApp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: context.theme.greyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ContactCard(
                          contactSource: firebaseContact,
                          onTap: () {
                            Navigator.of(context).push(NavigationPage(
                                child: ChatsPage(user: firebaseContact)));
                          },
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == allContacts[0].length)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(
                              'Invite to WhatsApp',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ContactCard(
                          contactSource: phoneContacts,
                          onTap: () => shareSmsLink(phoneContacts.phoneNumber),
                        )
                      ],
                    );
            },
          );
        },
        error: (error, stackTrace) {
          return const SizedBox();
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: context.theme.authAppbarTextColor,
            ),
          );
        },
      ),
    );
  }
}

ListTile myListTile({
  required IconData leading,
  required String text,
  IconData? trailing,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: Coloors.greenDark,
      child: Icon(
        leading,
        color: Colors.white,
      ),
    ),
    title: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(
      trailing,
      color: Coloors.greyDark,
    ),
  );
}

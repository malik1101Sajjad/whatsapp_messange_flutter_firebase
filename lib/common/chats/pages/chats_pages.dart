import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_me/common/chats/controller/chats_contoller.dart';
import 'package:whatsapp_me/common/chats/pages/profile_page.dart';
import 'package:whatsapp_me/common/chats/widgets/chat_text_field.dart';
import 'package:whatsapp_me/common/chats/widgets/yellow_card.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/helper/last_seen_messags.dart';
import 'package:whatsapp_me/common/models/user_model.dart';
import 'package:whatsapp_me/common/routs/routs.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import '../../enum/message_type.dart' as my_type;

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key, required this.user});
  final UserModel user;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: context.theme.chatPageBgColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back),
                Flexible(
                  child: Hero(
                    tag: 'profile',
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                  ),
                ),
                // const SizedBox(width: 5),
                // Text(user.username)
              ],
            ),
          ),
          title: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(NavigationPage(child: ProfilePage(usrer: user)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(color: Colors.white),
                ),
                StreamBuilder(
                  stream: ref
                      .read(authControllerProvide)
                      .getUserPresenceStatus(uid: user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const SizedBox();
                    }
                    final singleUser = snapshot.data!;

                    final lastseen = lastSeenMessags(singleUser.lastSeen);
                    return Text(
                      singleUser.active ? "online" : "last seen $lastseen ago",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              color: Colors.white,
            ),
          ],
        ),
        body: Stack(
          children: [
            Image(
              height: double.maxFinite,
              width: double.maxFinite,
              image: const AssetImage('assets/images/doodle_bg.png'),
              fit: BoxFit.cover,
              color: context.theme.photoIconBgColor,
            ),
            Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: ref
                      .watch(chatControllerProvider)
                      .getAllOneToOneMessage(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        final isSender = message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid;
                        final haveNip = (index == 0) ||
                            (index == snapshot.data!.length - 1 &&
                                message.senderId !=
                                    snapshot.data![index - 1].senderId) ||
                            (message.senderId !=
                                    snapshot.data![index - 1].senderId &&
                                message.senderId ==
                                    snapshot.data![index + 1].senderId) ||
                            (message.senderId !=
                                    snapshot.data![index - 1].senderId &&
                                message.senderId !=
                                    snapshot.data![index + 1].senderId);

                        return Column(
                          children: [
                            if (index == 0) const YellowCard(),
                            Container(
                              alignment: isSender
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,

                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isSender
                                          ? context.theme.senderChatCardBg
                                          : context.theme.receiverChatCardBg,
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 30),
                                            child: Text(message.textMessage,
                                                style: const TextStyle(
                                                    fontSize: 16))),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Text(
                                              DateFormat.Hm().format(
                                                message.timeSent,
                                              ),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      context.theme.greyColor)),
                                        )
                                      ],
                                    )),
                              ),
                              // margin: EdgeInsets.only(
                              //   top: 4,
                              //   bottom: 4,
                              //   left: isSender
                              //       ? 80
                              //       : haveNip
                              //           ? 10
                              //           : 15,
                              //   right: isSender
                              //       ? haveNip
                              //           ? 10
                              //           : 15
                              //       : 80,
                              // ),
                              // child: ClipPath(
                              //   clipper: haveNip
                              //       ? UpperNipMessageClipperTwo(
                              //           isSender
                              //               ? MessageType.send
                              //               : MessageType.receive,
                              //           nipWidth: 8,
                              //           nipHeight: 10,
                              //           bubbleRadius: haveNip ? 12 : 0,
                              //         )
                              //       : null,
                              //   child: Stack(
                              //     children: [
                              //       Container(
                              //         decoration: BoxDecoration(
                              //           color: isSender
                              //               ? context.theme.senderChatCardBg
                              //               : context.theme.receiverChatCardBg,
                              //           borderRadius: haveNip
                              //               ? null
                              //               : BorderRadius.circular(12),
                              //           boxShadow: const [
                              //             BoxShadow(color: Colors.black38),
                              //           ],
                              //         ),
                              //         child: Padding(
                              //           padding:
                              //               const EdgeInsets.only(bottom: 5),
                              //           child: message.type ==
                              //                   my_type.MessageType.image
                              //               ? Padding(
                              //                   padding: const EdgeInsets.only(
                              //                       right: 3, top: 3, left: 3),
                              //                   child: ClipRRect(
                              //                     borderRadius:
                              //                         BorderRadius.circular(12),
                              //                     child: Image(
                              //                       image: NetworkImage(
                              //                           message.textMessage),
                              //                     ),
                              //                   ),
                              //                 )
                              //               : Padding(
                              //                   padding: EdgeInsets.only(
                              //                     top: 8,
                              //                     bottom: 8,
                              //                     left: isSender ? 10 : 15,
                              //                     right: isSender ? 15 : 10,
                              //                   ),
                              //                   child: Text(
                              //                     "${message.textMessage}         ",
                              //                     style: const TextStyle(
                              //                         fontSize: 16),
                              //                   ),
                              //                 ),
                              //         ),
                              //       ),
                              //       Positioned(
                              //         bottom: message.type ==
                              //                 my_type.MessageType.text
                              //             ? 8
                              //             : 4,
                              //         right: message.type ==
                              //                 my_type.MessageType.text
                              //             ? isSender
                              //                 ? 15
                              //                 : 10
                              //             : 4,
                              //         child: message.type ==
                              //                 my_type.MessageType.text
                              //             ? Text(
                              //                 DateFormat.Hm()
                              //                     .format(message.timeSent),
                              //                 style: TextStyle(
                              //                   fontSize: 11,
                              //                   color: context.theme.greyColor,
                              //                 ),
                              //               )
                              //             : Container(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 90,
                              //                     right: 10,
                              //                     bottom: 10,
                              //                     top: 14),
                              //                 decoration: BoxDecoration(
                              //                   gradient: LinearGradient(
                              //                     begin: const Alignment(0, -1),
                              //                     end: const Alignment(1, 1),
                              //                     colors: [
                              //                       context.theme.greyColor!
                              //                           .withOpacity(0),
                              //                       context.theme.greyColor!
                              //                           .withOpacity(.5),
                              //                     ],
                              //                   ),
                              //                   borderRadius:
                              //                       const BorderRadius.only(
                              //                     topLeft: Radius.circular(300),
                              //                     bottomRight:
                              //                         Radius.circular(100),
                              //                   ),
                              //                 ),
                              //                 child: Text(
                              //                   DateFormat.Hm()
                              //                       .format(message.timeSent),
                              //                   style: const TextStyle(
                              //                     fontSize: 11,
                              //                     color: Colors.white,
                              //                   ),
                              //                 ),
                              //               ),
                              //       )
                              // ],
                              //     ),
                              // )
                            ),
                          ],
                        );
                      },
                    );
                  },
                )),
                ChatTextField(receiverId: user.uid)
              ],
            )
          ],
        ));
  }
}

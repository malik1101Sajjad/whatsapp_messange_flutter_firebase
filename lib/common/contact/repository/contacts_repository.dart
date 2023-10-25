import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_me/common/models/user_model.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(firebaseFirestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  final FirebaseFirestore firebaseFirestore;
  ContactsRepository({required this.firebaseFirestore});
  Future<List<List>> getContacAll() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];
    try {
      
      if (await FlutterContacts.requestPermission()) {
         final userCollection = await firebaseFirestore.collection('users').get();
        final phoneNumbersInFirebase = Set<String>();

        for (var firebaseContactData in userCollection.docs) {
          var firebaseContact = UserModel.fromMap(firebaseContactData.data());
          phoneNumbersInFirebase.add(firebaseContact.phoneNumber);
          firebaseContacts.add(firebaseContact);
        }

        final allContactsInPhone =
            await FlutterContacts.getContacts(withProperties: true);
             for (var contact in allContactsInPhone) {
          final phoneNumber = contact.phones[0].number.replaceAll(' ', '');
          if (phoneNumbersInFirebase.contains(phoneNumber)) {
            // This contact exists in Firebase.
            // You can add it to firebaseContacts if needed.
          } else {
            phoneContacts.add(
              UserModel(
                username: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: phoneNumber,
                groupId: [],
              ),
            );
          }
        }

        
        // final userCollection =
        //     await firebaseFirestore.collection('users').get();
        // final allContactsInPhone =
        //     await FlutterContacts.getContacts(withProperties: true);
       
        // for (var contact in allContactsInPhone) {
        //    bool isContacts = false;
        //   for (var firebaseContactData in userCollection.docs) {
        //     var firebaseContact = UserModel.fromMap(firebaseContactData.data());
        //     if (contact.phones[0].number.replaceAll('', '') ==
        //         firebaseContact.phoneNumber) {
        //       firebaseContacts.add(firebaseContact);
        //       isContacts = true;
        //       break;
        //     }
        //   }
        //   if (!isContacts) {
        //     phoneContacts.add(UserModel(
        //         username: contact.displayName,
        //         uid: '',
        //         profileImageUrl: '',
        //         active: false,
        //         lastSeen: 0,
        //         phoneNumber: contact.phones[0].number.replaceAll('', ''),
        //         groupId: []));
        //   }
        //   isContacts = false;
        // }
      }
    } catch (e) {
      print(" error message $e");
    }
    print("Firebase Contacts: $firebaseContacts");
    print("Phone Contacts: $phoneContacts");
    return [firebaseContacts, phoneContacts];
  }
}

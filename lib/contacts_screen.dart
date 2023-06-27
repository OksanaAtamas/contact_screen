import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contact_details_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contactsData =
      await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        contacts = contactsData.toList();
      });
    } else if (await Permission.contacts.isPermanentlyDenied) {
      showPermissionSettingsDialog();
    }
  }

  void showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Немає доступу до контактів'),
          content: Text('Надайте доступ в налаштуваннях телефону'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void openAppSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мої контакти'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = contacts[index];
          return ListTile(
            leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
                ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar!),
            )
                : CircleAvatar(
              child: Text(contact.initials() ?? ''),
            ),
            title: Text(contact.givenName ?? ''),
            subtitle: Text(
                contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : ''),
            onTap: () async {
              var updatedContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailsScreen(
                    contact: contact,
                    contacts: contacts,
                  ),
                ),
              );
              if (updatedContact != null) {
                setState(() {
                  contacts[index] = updatedContact;
                });
              }
            },
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;
  final List<Contact> contacts;

  ContactDetailsScreen({required this.contact, required this.contacts});

  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  String? avatarPath;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.givenName ?? '';
    phoneController.text = widget.contact.phones?.isNotEmpty == true
        ? widget.contact.phones!.first.value ?? ''
        : '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    if (await Permission.photos.request().isGranted) {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          avatarPath = image.path;
        });
      }
    } else if (await Permission.photos.isPermanentlyDenied) {
      showPermissionSettingsDialog();
    }
  }

  void showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Немає доступу до галереї'),
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
        title: Text('Деталі контакту'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.contact.avatar != null &&
                  widget.contact.avatar!.isNotEmpty)
                CircleAvatar(
                  backgroundImage: MemoryImage(widget.contact.avatar!),
                  radius: 50,
                )
              else if (avatarPath != null)
                CircleAvatar(
                  backgroundImage: FileImage(File(avatarPath!)),
                  radius: 50,
                )
              else
                CircleAvatar(
                  child: Text(widget.contact.initials() ?? ''),
                  radius: 50,
                ),
              SizedBox(height: 16.0),
              Text(
                'Ім\'я:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Введіть ім\'я',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Номер телефону:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Введіть номер телефону',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Зберегти'),
                onPressed: () {
                  saveContact();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveContact() {
    String name = nameController.text;
    String phone = phoneController.text;

    Contact updatedContact = Contact(
      givenName: name,
      phones: [Item(label: 'mobile', value: phone)],
      avatar: widget.contact.avatar,
    );

    int contactIndex = widget.contacts.indexOf(widget.contact);
    if (contactIndex != -1) {
      widget.contacts[contactIndex] = updatedContact;
    }

    Navigator.pop(context, updatedContact);
  }
}

import 'package:flutter/material.dart';
import 'contacts_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsScreen(),
    );
  }
}

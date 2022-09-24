// flutter and ui libraries
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// amplify configuration and models that should have been generated for you
import 'screens/EnquiriesPage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Enquiries',
      home: EnquiriesPage(),
    );
  }
}

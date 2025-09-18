import 'package:flutter/material.dart';
import 'package:foodsave_app/presentation/pages/auth/user_type_selection_page.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Page Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserTypeSelectionPage(),
    );
  }
}
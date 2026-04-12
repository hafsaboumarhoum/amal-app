import 'package:flutter/material.dart';

class SpecialistDirectoryScreen extends StatelessWidget {
  final String language;
  const SpecialistDirectoryScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'دليل المختصين' : 'Specialist Directory'),
        backgroundColor: const Color(0xFFBDA6CE),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          isArabic ? 'قريباً...' : 'Coming soon...',
          style: const TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
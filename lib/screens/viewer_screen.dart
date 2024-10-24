import 'package:flutter/material.dart';

class ViewerScreen extends StatelessWidget {
  final List<Map<String, String>> profiles = [
    {'email': 'admin@example.com', 'role': 'Admin'},
    {'email': 'user1@example.com', 'role': 'User'},
    {'email': 'user2@example.com', 'role': 'User'},
    {'email': 'viewer@example.com', 'role': 'Viewer'},
  ];

  ViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Profiles'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(profile['email']!),
            subtitle: Text('Role: ${profile['role']}'),
          );
        },
      ),
    );
  }
}

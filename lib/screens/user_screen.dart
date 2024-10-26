import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

class UserScreen extends StatefulWidget {
  final String email; // Email passed to the screen
  final String role; // Role passed to the screen
  final String accessToken; // Access token required for API requests

  UserScreen({
    required this.email,
    required this.role,
    required this.accessToken,
  });

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display User Email
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Email: ${widget.email}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display User Role
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Role: ${widget.role}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Edit Profile Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the EditProfileScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        email: widget.email, // Pass current email
                        firstTimeLogin:
                            false, // Not the first-time login in this case
                        accessToken: widget
                            .accessToken, // Pass access token for authorized requests
                      ),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

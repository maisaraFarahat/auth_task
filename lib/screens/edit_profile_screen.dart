import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class EditProfileScreen extends StatefulWidget {
  final String email;
  final bool firstTimeLogin; // Indicates if this is the first-time login
  final String accessToken; // Access token for API requests

  EditProfileScreen({
    required this.email,
    required this.firstTimeLogin,
    required this.accessToken,
  });
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _passwordError; // For password validation error message

  @override
  void initState() {
    super.initState();
    _emailController.text =
        widget.email; // Pre-fill the email field with current email
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    var path = 'editProfile';
    if (widget.firstTimeLogin) {
      path = 'changePassword';
    }
    // Validate password: For first-time login, ensure password is not empty
    if (widget.firstTimeLogin && _passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required for first-time login';
        _isLoading = false;
      });
      return;
    }
    // API call to update the email and/or password
    final response = await http.patch(
      Uri.parse(
          '${Constants.Base_url}/users/$path'), // Use Constants.Base_url for update profile
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${widget.accessToken}', // Send the access token in the Authorization header
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text.isEmpty
            ? null
            : _passwordController
                .text, // Only send password if it's being updated
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')));
      Navigator.pop(context); // Go back after successful update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.firstTimeLogin
            ? Text('Change Password')
            : Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: widget.firstTimeLogin
                    ? 'New Password (Required)'
                    : 'New Password',
                errorText:
                    _passwordError, // Show validation error message if needed
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateProfile,
                    child: widget.firstTimeLogin
                        ? Text('Set Password')
                        : Text('Update Profile'),
                  ),
          ],
        ),
      ),
    );
  }
}

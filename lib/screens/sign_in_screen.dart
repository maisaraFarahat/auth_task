import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // This is where Constants.Base_url is defined
import 'edit_profile_screen.dart'; // Edit Profile Screen for the first-time login or user profile edits
import 'admin_screen.dart'; // Admin Screen
import 'user_screen.dart'; // User Screen
import 'viewer_screen.dart'; // Viewer Screen

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    // API call to sign in and get the user's role and "first_time" flag
    final response = await http.post(
      Uri.parse(
          '${Constants.Base_url}/auth/signin'), // Use Constants.Base_url for the API endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final role = data['userDto']['role']; // User role from backend
      final firstTime = data['first_time']; // First-time login flag
      final accessToken = data[
          'access_token']; // Access token to pass to the Edit Profile Screen

      // Check if it's the user's first login
      if (firstTime == true) {
        // Navigate to Edit Profile Screen for the user to change their password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              email: _emailController
                  .text, // Pass the current email to Edit Profile Screen
              firstTimeLogin:
                  true, // Tell the Edit Profile Screen this is a first-time login
              accessToken:
                  accessToken, // Pass the access token to the Edit Profile Screen
            ),
          ),
        );
      } else {
        print("inside the not first time and the roleis $role");
        // If not first-time login, navigate based on the user's role
        if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AdminScreen(
                      accessToken: accessToken,
                    )), // Navigate to Admin Screen
          );
        } else if (role == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserScreen(
                      email: _emailController.text,
                      accessToken: accessToken,
                      role: role,
                    )), // Navigate to User Screen
          );
        } else if (role == 'Viewer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ViewerScreen(
                      accessToken: accessToken,
                    )), // Navigate to Viewer Screen
          );
        }
      }
    } else {
      // Handle error for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials. Please try again.')),
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
        title: Text('Sign In'),
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
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
          ],
        ),
      ),
    );
  }
}

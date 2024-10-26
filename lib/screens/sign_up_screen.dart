import 'package:auth_task/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();

  // Role selection
  String _selectedRole = 'User'; // Default role

  // Available roles
  List<String> roles = ['Admin', 'User', 'Viewer'];

  Future<void> signUp() async {
    final url = Uri.parse('${Constants.Base_url}/auth/signup');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': _emailController.text,
          'role': _selectedRole,
        }),
      );

      if (response.statusCode == 201) {
        // User created successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully!')),
        );
      } else {
        // Some error happened, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle any exceptions, like network issues
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Role Dropdown
            DropdownButton<String>(
              value: _selectedRole,
              onChanged: (String? newRole) {
                setState(() {
                  _selectedRole = newRole!;
                });
              },
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

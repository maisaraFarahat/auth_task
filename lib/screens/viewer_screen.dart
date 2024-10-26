import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // Assume this contains the base URL for the API

class ViewerScreen extends StatefulWidget {
  final String accessToken; // Access token for API requests
  ViewerScreen(
      {required this.accessToken}); // Constructor to pass the access token
  @override
  _ViewerScreenState createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  List<Map<String, dynamic>> profiles =
      []; // List to store fetched user profiles
  bool _isLoading = true; // To show a loading indicator while fetching data
  String? _error; // To handle any errors that occur during the API call

  @override
  void initState() {
    super.initState();
    _fetchProfiles(); // Fetch user profiles when the screen is initialized
  }

  // Function to fetch user profiles from the API
  Future<void> _fetchProfiles() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.Base_url}/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${widget.accessToken}', // Send the access token in the Authorization header
        },
      ); // Fetch profiles from /users API
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Transform the data into a List of Map<String, String>
        setState(() {
          profiles = data.map((user) {
            return {'email': user['email'], 'role': user['role']};
          }).toList();
          _isLoading = false; // Stop the loading indicator
        });
      } else {
        // Handle API errors
        setState(() {
          _error = 'Failed to load profiles. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any other errors (e.g., network issues)
      setState(() {
        _error =
            'An error occurred. Please check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Profiles'),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : _error != null
              ? Center(
                  child: Text(
                      _error!)) // Show error message if something goes wrong
              : ListView.builder(
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

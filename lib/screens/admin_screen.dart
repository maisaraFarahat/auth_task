import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // Assume this contains the base URL for the API

class AdminScreen extends StatefulWidget {
  final String accessToken; // Access token passed from the Sign In Screen

  AdminScreen({required this.accessToken});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> users = []; // Store users fetched from the backend
  final List<String> roles = [
    'Admin',
    'User',
    'Viewer'
  ]; // List of roles the admin can assign
  Map<int, String> roleChanges =
      {}; // Store temporary role changes before saving
  bool _isLoading = true; // To show a loading indicator
  String? _error; // To handle any errors during the API call

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the screen is initialized
  }

  // Fetch all users from the backend API
  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.Base_url}/users'),
        headers: {
          'Authorization':
              'Bearer ${widget.accessToken}', // Pass the access token in the headers
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          users = data.map((user) {
            return {
              'id': user['id'],
              'email': user['email'],
              'role': user['role'],
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load users. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error =
            'An error occurred. Please check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  // Apply role changes for a specific user by making an API request
  Future<void> _applyRoleChange(int index, String userId) async {
    final newRole = roleChanges[index];
    if (newRole == null) return;

    try {
      final response = await http.patch(
        Uri.parse('${Constants.Base_url}/users/editRole/$userId'),
        headers: {
          'Authorization':
              'Bearer ${widget.accessToken}', // Include access token in headers
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'roleName': newRole}),
      );

      if (response.statusCode == 200) {
        // Update the user's role locally after successful API call
        setState(() {
          users[index]['role'] = newRole;
          roleChanges.remove(index); // Remove the change from the temporary map
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Role updated successfully!'),
        ));
      } else {
        throw Exception('Failed to update role');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update role. Please try again.'),
      ));
    }
  }

  // Delete a user by making an API request
  Future<void> _deleteUser(int index, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.Base_url}/users/deleteUser/$userId'),
        headers: {
          'Authorization':
              'Bearer ${widget.accessToken}', // Include access token in headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Remove the user from the local list after successful deletion
        setState(() {
          users.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User deleted successfully!'),
        ));
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete user. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : _error != null
              ? Center(
                  child: Text(
                      _error!)) // Show error message if something goes wrong
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage User Roles',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final currentRole = roleChanges.containsKey(index)
                                ? roleChanges[index]
                                : user['role'];

                            return Dismissible(
                              key: Key(user['id']
                                  .toString()), // Use user ID as key for dismissible
                              direction: DismissDirection
                                  .endToStart, // Swipe from right to left to delete
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                _deleteUser(index, user['id'].toString());
                              },
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(user['email']),
                                subtitle: Text('Role: $currentRole'),
                                trailing: DropdownButton<String>(
                                  value: currentRole,
                                  items: roles.map((String role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(role),
                                    );
                                  }).toList(),
                                  onChanged: (newRole) {
                                    setState(() {
                                      roleChanges[index] =
                                          newRole!; // Store the change temporarily
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Apply role changes for all users
                            for (var index in roleChanges.keys) {
                              await _applyRoleChange(
                                  index, users[index]['id'].toString());
                            }
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

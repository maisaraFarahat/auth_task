import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Simulate a list of users with their email and roles
  List<Map<String, String>> users = [
    {'email': 'admin@example.com', 'role': 'Admin'},
    {'email': 'user1@example.com', 'role': 'User'},
    {'email': 'user2@example.com', 'role': 'User'},
    {'email': 'viewer@example.com', 'role': 'Viewer'},
  ];

  // List of roles the admin can assign
  final List<String> roles = ['Admin', 'User', 'Viewer'];

  // Temporary map to store changes before saving
  Map<int, String> roleChanges = {};

  // Function to temporarily update the user's role in roleChanges
  void _onRoleChange(int index, String? newRole) {
    if (newRole != null) {
      setState(() {
        roleChanges[index] = newRole;
      });
    }
  }

// @TODO: use later to include api in the screen
// Future<void> _applyChanges() async {
//   try {
//     for (int index in roleChanges.keys) {
//       final user = users[index];
//       final newRole = roleChanges[index];

//       // Make API call to update the role for this user
//       await api.updateUserRole(user['email'], newRole);
//     }

//     // Apply changes to local list
//     setState(() {
//       roleChanges.forEach((index, newRole) {
//         users[index]['role'] = newRole;
//       });
//       roleChanges.clear();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Roles updated successfully!'),
//     ));
//   } catch (error) {
//     // Handle any errors, like failed network requests
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Failed to update roles'),
//     ));
//   }
// }

  // Function to apply all changes when Save is pressed
  void _applyChanges() {
    setState(() {
      roleChanges.forEach((index, newRole) {
        users[index]['role'] = newRole;
      });

      // Clear the roleChanges map after applying changes
      roleChanges.clear();
    });

    // Notify the admin that the changes were saved
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Roles updated successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage User Roles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user['email']!),
                    subtitle: Text('Role: ${currentRole}'),
                    trailing: DropdownButton<String>(
                      value:
                          currentRole, // Current role (either from roleChanges or original)
                      items: roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (newRole) {
                        _onRoleChange(
                            index, newRole); // Store the change temporarily
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed:
                    _applyChanges, // Apply changes when the Save button is pressed
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

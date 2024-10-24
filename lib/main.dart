import 'package:flutter/material.dart';
import 'screens/admin_screen.dart';
import 'screens/user_screen.dart';
import 'screens/viewer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleBasedHomeScreen(),
        '/admin': (context) => AdminScreen(),
        '/user': (context) => UserScreen(),
        '/viewer': (context) => ViewerScreen(),
      },
    );
  }
}

class RoleBasedHomeScreen extends StatelessWidget {
  // Simulate getting the user role from an API or backend
  final String userRole = "Viewer";

  const RoleBasedHomeScreen(
      {super.key}); // Change to "Admin", "User", or "Viewer"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Based Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Role Based App!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the appropriate screen based on user role
                if (userRole == 'Admin') {
                  Navigator.pushNamed(context, '/admin');
                } else if (userRole == 'User') {
                  Navigator.pushNamed(context, '/user');
                } else if (userRole == 'Viewer') {
                  Navigator.pushNamed(context, '/viewer');
                } else {
                  print('Unknown role');
                }
              },
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

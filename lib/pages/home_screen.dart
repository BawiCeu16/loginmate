import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginmate/pages/login_screen.dart';
import 'package:loginmate/utils/auth_provider.dart' show AuthenProvider;
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? "User";
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display a welcome message with the user's email
              Text(
                "Welcome, $name!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text("Email:", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 10),
                  Text(
                    user?.email ?? "No Email Found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Logout button
              IconButton(
                onPressed: () async {
                  final auth = Provider.of<AuthenProvider>(
                    context,
                    listen: false,
                  );
                  await auth.logout();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

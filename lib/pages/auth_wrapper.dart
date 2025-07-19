import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginmate/pages/email_verify_screen.dart';
import 'package:loginmate/pages/home_screen.dart';
import 'package:loginmate/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> _checkAuthFlow() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        return const HomeScreen();
      } else {
        return const EmailVerifyScreen();
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final remember = prefs.getBool("remember_me") ?? false;

      if (remember) {
        // No Firebase user found, so clear memory
        await prefs.setBool("remember_me", false);
      }

      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkAuthFlow(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Something went wrong"),
                  SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text("Go to Login"),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

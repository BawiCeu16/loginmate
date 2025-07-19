import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loginmate/pages/home_screen.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  late Timer timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sendVerificationEmail(); // Send first email
    timer = Timer.periodic(Duration(seconds: 2), (_) => checkIfVerified());
  }

  // 🔁 Check if user has verified
  Future<void> checkIfVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      timer.cancel();

      // 🔒 Remember user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("remember_me", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // 📩 Resend verification email
  Future<void> sendVerificationEmail() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification email sent to ${user.email}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send email: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? "";

    return Scaffold(
      appBar: AppBar(title: Text("Email Verification")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to:",
              textAlign: TextAlign.center,
            ),
            Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Please check your inbox and click the verification link."),
            SizedBox(height: 30),
            FilledButton(
              onPressed: isLoading ? null : sendVerificationEmail,
              child: Text(isLoading ? "Sending..." : "Resend Email"),
            ),
            SizedBox(height: 20),
            Text(
              "This screen will redirect to home once verified.",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

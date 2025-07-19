import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetLink() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password Reset Email Sent"),
          content: Text(
            "A password reset email has been sent!. Please check your inbox.",
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Okay"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send email')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Function to validate email format
  // This function checks if the email is in a valid format
  // using a regular expression.
  // Returns true if the email is valid, false otherwise.
  // This is a simple validation and may not cover all edge cases.
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(title: const Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 4),
              Text(
                "Loginmate",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Spacer(),
              //Email TextField
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                    // ignore: deprecated_member_use
                  ).colorScheme.surfaceContainerLow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Removes the underline
                    hintText: 'Enter email',
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: FilledButton(
                  // onPressed: () {
                  onPressed: () {
                    final email = emailController.text.trim();

                    if (email.isEmpty) {
                      // Show error dialog for empty fields
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Missing Information",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          content: Text("Plase enter your email."),
                          actions: [
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Okay"),
                            ),
                          ],
                        ),
                      );
                    } else if (!isValidEmail(email)) {
                      // Show error dialog for invalid email
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Vailed Email",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          content: Text("Plase enter a vailed email address."),
                          actions: [
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Okay"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      sendResetLink();

                      // Clear the email field after sending the reset email
                      emailController.clear();
                    }
                  },
                  child: Text(isLoading ? 'Sending...' : 'Send Reset Link'),
                ),
              ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}

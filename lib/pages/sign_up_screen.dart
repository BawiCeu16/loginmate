import 'package:flutter/material.dart';
import 'package:loginmate/pages/email_verify_screen.dart';
import 'package:loginmate/pages/login_screen.dart';
import 'package:loginmate/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool noEmailAndPassError = true;
  bool noPassword = true;
  bool isLoading = false;
  bool showPass = true;

  //Sign Up Function
  void register(BuildContext context) async {
    final auth = Provider.of<AuthenProvider>(context, listen: false);
    setState(() => isLoading = true);
    final message = await auth.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );
    setState(() => isLoading = false);
    if (message == null) {
      // If registration is successful, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      // Show success message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerifyScreen()),
      );
    } else {
      // Show error message if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: "Login",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  // Validate Email Function
  // This function checks if the email is valid using a regular expression
  // It returns true if the email matches the pattern, otherwise false.
  // This is useful for ensuring that the user enters a correctly formatted email address.
  // It can be used in forms to validate user input before submission.
  // Example usage: isValidEmail("test@example.com");
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              //Name TextField
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none, // Removes the underline
                    hintText: 'Enter name',
                  ),
                ),
              ),
              SizedBox(height: 20),

              //Email TextField
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Removes the underline
                    hintText: 'Enter email',
                  ),
                ),
              ),
              SizedBox(height: 20),
              //Password TextField
              Container(
                padding: EdgeInsets.only(
                  left: 15.0,
                  top: 3.0,
                  right: 3.0,
                  bottom: 3.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        obscureText: showPass,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Removes the underline
                          hintText: 'Enter password',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: showPass
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //ask to go to Register screen
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Already have an account?"),
                  SizedBox(width: 10),
                  //go to RegisterScreen
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              isLoading
                  // If loading, show a progress indicator
                  ? const CircularProgressIndicator()
                  // If not loading, show the register button
                  : SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: FilledButton(
                        // onPressed: () {
                        //   //check for TextFields
                        //   if (emailController.text.isEmpty ||
                        //       passwordController.text.isEmpty) {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => AlertDialog(
                        //         title: Text(
                        //           "Missing Informations",
                        //           style: TextStyle(
                        //             color: Theme.of(context).colorScheme.error,
                        //           ),
                        //         ),
                        //         content: Text("Fill you email and Password"),
                        //         actions: [
                        //           FilledButton(
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //             child: Text("Okay"),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   } else {
                        //     register(context);
                        //   }
                        // },
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          if (email.isEmpty || password.isEmpty) {
                            //  Show error if email or password is empty
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Missing Information",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                content: Text(
                                  "Plase enter both email and password.",
                                ),
                                actions: [
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Okay"),
                                  ),
                                ],
                              ),
                            );
                          } else if (nameController.text.isEmpty) {
                            //  Check if the name is empty
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Missing Name!",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                content: Text("Please enter your name."),
                                actions: [
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Okay"),
                                  ),
                                ],
                              ),
                            );
                          } else if (!isValidEmail(email)) {
                            //  Check if the email is valid
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Vailed Email!",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                content: Text(
                                  "Plase enter a vailed email address.",
                                ),
                                actions: [
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Okay"),
                                  ),
                                ],
                              ),
                            );
                          } else if (password.length < 6) {
                            // Show error for weak password
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Weak Password!",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                content: Text(
                                  "Password must be at least 6 characters.",
                                ),
                                actions: [
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Okay"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            register(context);
                          }
                        },
                        child: Text("Sign Up"),
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

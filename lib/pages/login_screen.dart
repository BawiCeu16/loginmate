import 'package:flutter/material.dart';
import 'package:loginmate/pages/forgot_password_screen.dart';
import 'package:loginmate/pages/home_screen.dart';
import 'package:loginmate/pages/sign_up_screen.dart';
import 'package:loginmate/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool noEmailError = true;
  bool noPassword = true;
  bool isLoading = false;
  bool showPass = true;

  //Login Function
  void login(BuildContext context) async {
    final auth = Provider.of<AuthenProvider>(context, listen: false);
    setState(() => isLoading = true);
    final message = await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() => isLoading = false);

    if (message == null) {
      // If login is successful, navigate to HomeScreen
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      // Show success message
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Login Successful")));
    } else {
      // If login fails, show error message
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
                    // ignore: deprecated_member_use
                  ).colorScheme.surfaceContainerLow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        obscureText: showPass,
                        decoration: InputDecoration(
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
                  Text("Forgot Password?"),
                  SizedBox(width: 5.0),
                  //go to RegisterScreen
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        "Reset",
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
                  // If not loading, show the login button
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
                        //     login(context);
                        //   }
                        // },
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
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
                          } else {
                            login(context);
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),

              SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text("Go to SignUp"),
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

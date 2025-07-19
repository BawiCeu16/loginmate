import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginmate/firebase_options.dart';
import 'package:loginmate/pages/auth_wrapper.dart';
import 'package:loginmate/utils/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Set the status bar color to transparent
      systemNavigationBarColor:
          Colors.transparent, // Set the navigation bar color to transparent
      systemNavigationBarIconBrightness:
          Brightness.dark, // Set navigation bar icons to dark
      statusBarIconBrightness: Brightness.dark, // Set status bar icons to dark
    ),
  ); // Set the system UI overlay style
  //Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthenProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loginmate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        splashFactory: NoSplash.splashFactory,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        splashFactory: NoSplash.splashFactory,
      ),
      themeMode: ThemeMode.system,
      home: AuthWrapper(),
    );
  }
}

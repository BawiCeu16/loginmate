import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  bool isLoggedIn = false;

  AuthenProvider() {
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    // Check if the user is already logged in
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool("remember_me") ?? false;
    if (remembered && _auth.currentUser != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    try {
      // Automatically log in if the user is already logged in
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("remember_me", true);
      isLoggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await _auth.currentUser?.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.uid)
          .set({'name': name, 'email': email, 'createdAt': Timestamp.now()});

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    // Clear the remember me status on logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember_me", false);
    await _auth.signOut();
    isLoggedIn = false;
    notifyListeners();
  }
}

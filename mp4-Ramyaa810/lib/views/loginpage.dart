import 'package:battleships/utils/api_service.dart';
import 'package:battleships/views/homescreen.dart';
import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
part "loginscreen.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  late Future<String> homeScreenUsername;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    String username = await SessionManager.getusername();

    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
        SessionManager.setUsername(username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loginpage',
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

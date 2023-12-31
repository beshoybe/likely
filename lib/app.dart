import 'package:flutter/material.dart';
import 'package:grad/modules/auth/login/login_screen.dart';

class BikeApp extends StatelessWidget {
  const BikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginScreen());
  }
}

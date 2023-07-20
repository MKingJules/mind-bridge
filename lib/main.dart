import 'package:flutter/material.dart';
import 'package:mind_bridge/screens/login_screen.dart';
import 'package:mind_bridge/screens/register_screen.dart';
import 'constants/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
      },
      home: const LoginScreen(),
    );
  }
}

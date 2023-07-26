import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mind_bridge/screens/home_screen.dart';
import 'package:mind_bridge/screens/login_screen.dart';
import 'package:mind_bridge/screens/register_screen.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get homescreenRoute => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Bridge',
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? loginRoute
          : homescreenRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        homeScreenRoute: (context) => const HomeScreen()
      },
      home: const HomeScreen(),
    );
  }
}

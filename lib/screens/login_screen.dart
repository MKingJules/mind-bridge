import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_bridge/constants/push_routes.dart';
import 'package:mind_bridge/constants/routes.dart';
import '../show_error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void pushHome() {
    pushReplacementRoute(context, homeScreenRoute);
  }

  Future<String?> getEmailFromUsername(String username) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      if (snapshot.size > 0) {
        final DocumentSnapshot document = snapshot.docs.first;
        return document.id;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 150),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.transparent,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Form(
                            key: formKey,
                            child: TextField(
                              controller: usernameController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(80),
                                  ),
                                ),
                                labelText: 'Username',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: passwordController,
                            maxLines: 1,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(80),
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.lock_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 43,
                      right: 35,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            String name = usernameController.text;
                            String? email = await getEmailFromUsername(name);
                            String password = passwordController.text;
                            final form = formKey.currentState!;
                            if (form.validate()) {}
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email!, password: password);
                            pushHome();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              await showErrorDialog(context, 'User not found');
                            } else if (e.code == 'wrong-password') {
                              await showErrorDialog(context, 'Wrong password');
                            } else {
                              await showErrorDialog(context, 'Error: $e.code');
                            }
                          } catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.lightBlueAccent,
                            child: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 250),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlueAccent),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(60),
                                    bottomRight: Radius.circular(60))))),
                    onPressed: () {
                      pushReplacementRoute(context, registerRoute);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Register',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

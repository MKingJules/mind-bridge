import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_bridge/constants/push_routes.dart';
import 'package:mind_bridge/constants/routes.dart';
import '../show_error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void validator(emailController) =>
      emailController != null && !EmailValidator.validate(emailController)
          ? 'Enter a valid email'
          : null;

  void pushHome() {
    pushReplacementRoute(context, homeScreenRoute);
  }

  Future<void> addUser(String email, String username) async {
    final CollectionReference users = _firestore.collection('users');
    await users.doc(email).set({
      'username': username,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background_green.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 150),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 250),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreenAccent),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    bottomLeft: Radius.circular(60))))),
                    onPressed: () {
                      pushReplacementRoute(context, loginRoute);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Login',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Register',
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                              labelText: 'Password',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.lock_outlined),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: emailController,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            enableSuggestions: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(80),
                                ),
                              ),
                              labelText: 'Email Address',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 75,
                      right: 35,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            String username = usernameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            final form = formKey.currentState!;
                            if (form.validate()) {}
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            addUser(email, username);
                            pushHome();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              await showErrorDialog(context,
                                  "Weak password : Password should be above 6 characters");
                            } else if (e.code == 'invalid-password') {
                              await showErrorDialog(
                                  context, 'Invalid-password');
                            } else if (e.code == 'email-already-in-use') {
                              await showErrorDialog(context,
                                  'Email belongs to other user: Register with a different email');
                            } else {
                              await showErrorDialog(context, 'Error: $e.code');
                            }
                          } on TypeError catch (e) {
                            await showErrorDialog(context, e.toString());
                          } catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.lightGreenAccent,
                            child: const Icon(Icons.check),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

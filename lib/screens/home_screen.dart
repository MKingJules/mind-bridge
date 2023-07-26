import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_bridge/constants/routes.dart';

import '../constants/push_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String? name;

  Future<String?> getUsernameFromEmail(String email) async {
    String? username;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (snapshot.exists) {
        username = snapshot.data()?['username'];
      }
    } catch (e) {
      rethrow;
    }
    return username;
  }

  void setUsername() async{
      String? username = await getUsernameFromEmail(email);
      setState(() {
        name = username!;
      });
  }

  @override
  void initState(){
    super.initState();
    setUsername();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: ClipOval(
              child: Image.asset(
                'assets/profile.jpeg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                pushReplacementRoute(context, loginRoute);
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 680,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Text(
                    'Hello, $name!',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        circleCard('assets/weather.jpeg', 'Weather'),
                        circleCard('assets/breathing.jpeg', 'Breathing'),
                        circleCard('assets/music.jpeg', 'Playlist'),
                        circleCard('assets/rest.jpeg', 'Rest'),
                        circleCard('assets/water.jpeg', 'Water'),
                        circleCard('assets/books.jpeg', 'Books'),
                        circleCard('assets/exercise.jpeg', 'Workouts'),
                        circleCard('assets/friends.jpeg', 'Friends'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.lightGreenAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            'assets/therapy.png',
                            height: 280,
                            width: 350,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Feeling meh?? Talk to a therapist',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'About You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  homeScreenCard('assets/smile.jpeg', 'how are you feeling?'),
                  const SizedBox(
                    height: 10,
                  ),
                  homeScreenCard('assets/group.jpeg', 'who are you with?'),
                  const SizedBox(
                    height: 10,
                  ),
                  homeScreenCard('assets/location.png', 'where are you?'),
                  const SizedBox(
                    height: 10,
                  ),
                  homeScreenCard(
                      'assets/weather.jpeg', "what's the weather like?"),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Close Friends',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.lightGreenAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            'assets/friends.jpeg',
                            height: 280,
                            width: 350,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Want to speak to some close friends?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Journal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.lightGreenAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            'assets/journal.jpeg',
                            height: 280,
                            width: 350,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Want to update your journal?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.home_outlined,
                      size: 35,
                    ),
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.air,
                      size: 35,
                    ),
                  ),
                  label: 'Breathe'),
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.heart,
                      size: 35,
                    ),
                  ),
                  label: 'Mood'),
              BottomNavigationBarItem(
                  icon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.insights,
                      size: 35,
                    ),
                  ),
                  label: 'Insights'),
              BottomNavigationBarItem(
                icon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person_outlined,
                    size: 35,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget homeScreenCard(String assetName, String text) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                assetName,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget circleCard(String assetName, String text){
  return Container(
    height: 100,
    width: 100,
    color: Colors.transparent,
    child: Column(
      children: [
        ClipOval(
          child: Image.asset(
            assetName,
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5,),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
        )
      ],
    ),
  );
}

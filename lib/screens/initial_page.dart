import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics2024/screens/bnb_screens/business_page.dart';
import 'package:firebase_analytics2024/screens/bnb_screens/home/home_page.dart';
import 'package:firebase_analytics2024/screens/bnb_screens/profile_page.dart';
import 'package:firebase_analytics2024/screens/notification.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int selectedIndex = 0;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static List pageNames = ['HomePage', 'BusinessPage', 'ProfilePage'];

  static const List<Widget> widgetOptions = <Widget>[
    HomePage(),
    BusinessPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.whatshot,
            color: Colors.red.shade700,
            size: 45,
          ),
        ),
        centerTitle: true,
        title: Text(
          'F i r e b a s e     A n a l y t i c s',
          style: TextStyle(
            color: Colors.grey.shade900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey.shade400,
        onTap: (index) async {
          await analytics.logEvent(name: 'pages_tracked', parameters: {
            "page_name": pageNames[index],
            "page_index": index,
          });
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

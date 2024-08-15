import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String? payload;

  const ProfilePage({super.key, this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: Colors.grey.shade900,
              size: 60,
            ),
            Text(
              'Profile Page',
              style: TextStyle(
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

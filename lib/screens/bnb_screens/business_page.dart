import 'package:flutter/material.dart';

class BusinessPage extends StatelessWidget {
  const BusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 60,
              color: Colors.grey.shade900,
            ),
            Text(
              'Business Page',
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

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_analytics2024/screens/notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider =
        Provider.of<HomeProvider>(context, listen: false);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationProvider.startProgress(context);
      _showNotificationDialog(context, message);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 60,
              color: Colors.grey.shade900,
            ),
            Text(
              'Home Page',
              style: TextStyle(
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, RemoteMessage message) {
    final notificationProvider =
        Provider.of<HomeProvider>(context, listen: false);

    if (notificationProvider.isDialogOpen) return;
    notificationProvider.setDialogOpen(true);

    final notification = message.data;
    String notificationJson = jsonEncode(notification);
    log(notificationJson);
    String formattedDateTime =
        DateFormat('dd-MM-yyyy | hh:mm a').format(DateTime.now());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.asset('assets/logo.png', height: 120),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 183, 243, 64),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Trip Details: $formattedDateTime',
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${notification['title']}',
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/oiot edited logo.png', height: 45),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${notification['body']}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              '⭐ ${notification['rating']} | Booking ID: ${notification['bookingId']}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Card(
                    color: Colors.blueGrey.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estimation Fare Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🛣️ ${notification['tripKm']} km',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '⌚ ${notification['tripTime']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '₹${notification['tripAmount']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            'Extra KM: ${notification['extraKm']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Extra Mins: ${notification['extraMin']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Base Fare: ${notification['baseFare']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      Text(
                          'Pickup Location: ${notification['pickUpLocation']}'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      Text('Drop Location: ${notification['dropLocation']}'),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                provider.stopProgress();
                                notificationProvider.setDialogOpen(false);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 183, 243, 64),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('REJECT'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                provider.stopProgress();
                                notificationProvider.setDialogOpen(false);
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(
                                      payload: notificationJson,
                                      title: notification['title'],
                                      body: notification['body'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 183, 243, 64),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('ACCEPT'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        minHeight: 10,
                        value: provider.progress,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 183, 243, 64),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      notificationProvider.setDialogOpen(false);
    });
  }
}

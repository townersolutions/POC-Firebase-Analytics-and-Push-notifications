import 'dart:convert';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String? payload;
  final String? title;
  final String? body;

  const NotificationScreen({super.key, this.payload, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    bool hasNotification = (title != null && title!.isNotEmpty) ||
        (body != null && body!.isNotEmpty) ||
        (payload != null && payload!.isNotEmpty);

    Map<String, dynamic>? notificationData;
    if (payload != null && payload!.isNotEmpty) {
      notificationData = Map<String, dynamic>.from(jsonDecode(payload!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rider Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: hasNotification
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (notificationData != null) ...[
                        _buildNotificationDetail(
                            'Title', notificationData['title']),
                        _buildNotificationDetail(
                            'Message', notificationData['body']),
                        _buildNotificationDetail(
                            'Rating', '⭐ ${notificationData['rating']}'),
                        _buildNotificationDetail('Booking ID',
                            notificationData['bookingId'].toString()),
                        _buildNotificationDetail('Trip Distance',
                            '${notificationData['tripKm']} km'),
                        _buildNotificationDetail(
                            'Trip Time', notificationData['tripTime']),
                        _buildNotificationDetail('Trip Amount',
                            '₹${notificationData['tripAmount']}'),
                        _buildNotificationDetail(
                            'Extra KM', notificationData['extraKm'].toString()),
                        _buildNotificationDetail('Extra Mins',
                            notificationData['extraMin'].toString()),
                        _buildNotificationDetail('Base Fare',
                            notificationData['baseFare'].toString()),
                        _buildNotificationDetail('Pickup Location',
                            notificationData['pickUpLocation']),
                        _buildNotificationDetail(
                            'Drop Location', notificationData['dropLocation']),
                      ],
                    ],
                  ),
                )
              : Text(
                  'No notifications',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildNotificationDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.teal.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

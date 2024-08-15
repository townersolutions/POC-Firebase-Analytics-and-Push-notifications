// // ignore_for_file: deprecated_member_use

// import 'package:firebase_database/firebase_database.dart';

// class DataService {
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.reference().child('your_data_node');

//   void listenToDataChanges() {
//     _dbRef.onChildChanged.listen((event) {
//       // Data has changed, send a notification
//       sendNotification(event.snapshot.value);
//     });
//   }

//   void sendNotification(dynamic data) {
//     // Implement your notification logic here
//     // You can use a package like http to send a request to your server
//     // Your server should then send a FCM message to the device
//   }
// }

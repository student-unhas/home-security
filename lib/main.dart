import 'package:audioplayers/audioplayers.dart';
import 'package:final_imran_salma/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AudioPlayer().play(AssetSource('sound.mp3'));
  debugPrint('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.subscribeToTopic("user");

  final fcmToken = await FirebaseMessaging.instance.getToken();

  print(fcmToken);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint("tap notif");
    // AudioPlayer().stop();
    // Uri.parse("tel:+6282399437738");
    AudioPlayer().stop();

    // Panggilan telepon
    String phoneNumber = "+6282399437738";
    String url = "tel:$phoneNumber";

    if (await canLaunchUrlString(url)) {
      Uri.parse(url);
    } else {
      debugPrint("Tidak dapat memulai panggilan telepon");
    }
  });

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      "high_importance_channel", // id
      "High Importance Notifications", // title
      // "This channel is used for important notifications.", // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

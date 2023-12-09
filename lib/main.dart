import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: const <String, WidgetBuilder>{},
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: const Text('Siap'),
    );
  }
}

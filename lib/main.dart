import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parallelchat/firebase_options.dart';
import 'package:parallelchat/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

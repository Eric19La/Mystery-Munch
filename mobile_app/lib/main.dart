import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  // print("Current Working Directory: ${Directory.current.path}");
  //
  // String envPath = ".env"; // Should now be in root directory
  //
  // // Check if file exists
  // bool fileExists = File(envPath).existsSync();
  // print("Does .env exist? $fileExists");
  //
  // if (fileExists) {
  //   String envFileContent = File(envPath).readAsStringSync();
  //   print("Manual .env Read:\n$envFileContent");
  // } else {
  //   print("ERROR: .env file not found at: $envPath");
  // }
  //
  // await dotenv.load(fileName: "/Users/eric/Desktop/Mystery-Munch/.env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystery Munch',
      theme: ThemeData(
        colorSchemeSeed: Colors.amber[50],
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

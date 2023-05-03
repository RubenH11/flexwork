import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;
import './flexwork.dart';
import "package:provider/provider.dart";
import 'models/newReservationNotifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Hook up to Firestore database
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBK9xQzpEgGfGxljk6L7oq1OUDQ10w7Kd0",
      appId: "1:598691515878:web:f30e1a8f34a75d16d45a27",
      messagingSenderId: "598691515878",
      projectId: "nu-flex-app",
      storageBucket: "nu-flex-app.appspot.com",
    ),
  );

  // Provide NewReservationNotifier
  runApp(ChangeNotifierProvider(
    create: (_) => NewReservationNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(0.0),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
              textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
              foregroundColor: MaterialStatePropertyAll(Colors.black),
              overlayColor:
                  MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0)),
            ),
          ),
          textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 12)),
              foregroundColor: MaterialStatePropertyAll(Colors.black),
              overlayColor:
                  MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0)),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black, fontSize: 12),
          ),
          cupertinoOverrideTheme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(fontSize: 12),
            ),
          ),
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromARGB(255, 134, 159, 249),
              onPrimary: Colors.white,
              secondary: Colors.grey,
              onSecondary: Colors.black,
              error: Color.fromARGB(255, 239, 141, 141),
              onError: Colors.white,
              background: Colors.grey.shade200,
              onBackground: Colors.black,
              surface: Colors.white,
              onSurface: Colors.grey)),
      home: Scaffold(
        body: FlexWork(),
      ),
    );
  }
}

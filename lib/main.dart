import 'package:flexwork/auth.dart';
import 'package:flexwork/user/flexwork.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "./helpers/firebaseService.dart";
import "./admin/admin.dart";
import "package:provider/provider.dart";
import 'models/newReservationNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

void main() async {
  // Hook up to Firestore database
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeApp();
  final _auth = FirebaseAuth.instance;

  // Provide NewReservationNotifier (should only be for users)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              headlineMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
                background: Colors.grey.shade300,
                onBackground: Colors.grey,
                surface: Colors.white,
                onSurface: Colors.grey)),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              if (userSnapshot.data!.uid == "XT2yrJzQp5hRvchjVtAl2VFJOZX2") {
                return Scaffold(body: Admin());
              }
              return Scaffold(body: FlexWork());
            } else {
              return Scaffold(body: Auth());
            }
          },
        ));
  }
}


// TODO:
// From advanced newSpace to rectangular newSpace disapearance
// From advanced newSpace to rectangular newSpace warning of disapearance

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "./helpers/firebaseService.dart";
import "./admin/admin.dart";
import "package:provider/provider.dart";
import 'models/newReservationNotifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Hook up to Firestore database
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeApp();

  // Provide NewReservationNotifier (should only be for users)
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewReservationNotifier(),
      child: StreamBuilder<QuerySnapshot>(
        //Stream accepts all workspaces (just their idetifiers)
        stream: FirebaseService().getAllSpacesStreamFromDB(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("An error occurred, please reload the page.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            );
          }
          //Future accepts the coordinates that come with the workspaces, such that the Workspace objects can be created
          return FutureBuilder(
            future: FirebaseService().getAllWorkspacesFromDB(snapshot.data!.docs),
            builder: (_, workspaces) {
              if (workspaces.hasError) {
                return const Text("An error occurred, please reload the page.");
              }

              if (workspaces.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary),
                );
              }
              // FirebaseService().printWorkspaces();
              return MyApp();
            },
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
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
              onBackground: Colors.grey,
              surface: Colors.white,
              onSurface: Colors.grey)),
      home: Scaffold(
        body: Admin(), //FlexWork(),
      ),
    );
  }
}


// TODO:
// From advanced newSpace to rectangular newSpace disapearance
// From advanced newSpace to rectangular newSpace warning of disapearance

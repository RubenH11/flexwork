import 'package:flexwork/auth/auth.dart';
import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/user/flexwork.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "./admin/admin.dart";
import "package:universal_html/html.dart" as html;

void main() async {
  // Hook up to Firestore database
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseService.initializeApp();
  // final _auth = FirebaseAuth.instance;
  // await FirebaseService().initializeState();

  // Provide NewReservationNotifier (should only be for users)
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
            headlineMedium: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          cupertinoOverrideTheme: const CupertinoThemeData(
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
      home: Scaffold(
        body: ChangeNotifierProvider.value(
          value: DatabaseFunctions(),
          builder: (context, _) {
            final t = Provider.of<DatabaseFunctions>(context);
            print("logged in!!!");
            if (DatabaseFunctions.getCookieValue('authToken') == null) {
              return AuthScreen();
            }

            return FlexworkFutureBuilder(
              future: DatabaseFunctions.getMyRole(),
              builder: (role) {
                print(role);
                if (role == 'admin') {
                  return Admin();
                } else if (role == 'user') {
                  return FlexWork();
                }
                return AuthScreen();
              },
            );
          },
        ),
      ),
      //const Scaffold(body: FlexWork()),
      // ChangeNotifierProvider(
      //   create: (context) => AdminState(),
      //   child: StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, userSnapshot) {
      //       if (userSnapshot.hasData) {
      //         print("tt");
      //         if (userSnapshot.data!.uid == "adlHpN0cY3bHT6KXPJuKSEVTJbk2") {
      //           return Scaffold(body: Admin());
      //         }
      //         print("tttt");
      //         return const Scaffold(body: FlexWork());
      //       } else {
      //         return Scaffold(body: AuthScreen());
      //       }
      //     },
      //   ),
      // ),
    );
  }
}

// TODO:
// From advanced newSpace to rectangular newSpace disapearance
// From advanced newSpace to rectangular newSpace warning of disapearance

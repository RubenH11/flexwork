import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/user/my_reservations/myReservationsContent.dart';
import 'package:flexwork/user/my_reservations/myReservationsMenu.dart';
import 'package:flexwork/user/new_reservation/content.dart';
import 'package:flexwork/user/new_reservation/menu.dart';
import 'package:flexwork/widgets/layout.dart';
import 'package:flexwork/widgets/navButton.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'my_reservations/myReservations.dart';

enum Pages {
  newReservation,
  myReservations,
}

class FlexWork extends StatefulWidget {
  const FlexWork({super.key});

  @override
  State<FlexWork> createState() => _FlexWorkState();
}

class _FlexWorkState extends State<FlexWork> {
  var selectedPage = Pages.newReservation;
  Widget menu = NewReservationMenu();
  Widget content = NewReservationContent();

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case Pages.myReservations:
        menu = MyReservationsMenu();
        content = MyReservationsContent();
        break;
      case Pages.newReservation:
        menu = NewReservationMenu();
        content = NewReservationContent();
        break;
    }

    return ChangeNotifierProvider(
      create: (context) => NewReservationNotifier(Floors.f9),
      child: Layout(
        navigation: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavButton(
              selected: selectedPage == Pages.newReservation,
              action: () {
                setState(() {
                  selectedPage = Pages.newReservation;
                });
              },
              text: "New reservation",
            ),
            Container(
              height: 25,
              width: 1,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            NavButton(
              selected: selectedPage == Pages.myReservations,
              action: () {
                setState(() {
                  selectedPage = Pages.myReservations;
                });
              },
              text: "My reservations",
            ),
          ],
        ),
        menu: menu,
        content: content,
      ),
    );
  }
}

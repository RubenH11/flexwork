import 'package:flexwork/new_reservation/newReservationStructure.dart';
import "package:flutter/material.dart";
import "./my_reservations/myReservations.dart";
import 'new_reservation/newReservationStructure.dart';

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
  var currentPage = Pages.newReservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton(
                    selected: currentPage == Pages.newReservation,
                    action: () {
                      setState(() {
                        currentPage = Pages.newReservation;
                      });
                    },
                    text: "New reservation"),
                const VerticalDivider(indent: 20, endIndent: 20),
                NavButton(
                    selected: currentPage == Pages.myReservations,
                    action: () {
                      setState(() {
                        currentPage = Pages.myReservations;
                      });
                    },
                    text: "My reservations"),
              ],
            ),
          ),
          Expanded(
            child: currentPage == Pages.myReservations ? MyReservations() : NewReservationStructure(),
          ),
        ],
      ),
    );
  }
}



class NavButton extends StatelessWidget {
  bool selected;
  Function action;
  String text;

  NavButton(
      {required this.selected,
      required this.action,
      required this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => action(),
      child: Text(
        text,
        style: selected
            ? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            : const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

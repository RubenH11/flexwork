import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'newResMenu.dart';
import "./newResContent.dart";
import '../models/newReservationNotifier.dart';

class NewReservationStructure extends StatefulWidget {
  const NewReservationStructure({super.key});

  @override
  State<NewReservationStructure> createState() =>
      _NewReservationStructureState();
}

class _NewReservationStructureState extends State<NewReservationStructure> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            width: 300,
            child: NewReservationMenu(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: NewReservationContent(),
            ),
          ),
        ],
      ),
    );
  }
}

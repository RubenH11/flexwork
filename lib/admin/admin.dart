import "package:flutter/material.dart";
import "./newSpace/newSpace.dart";

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _NewReservationStructureState();
}

class _NewReservationStructureState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: NewSpace(),
    );
  }
}

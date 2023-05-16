import "package:flutter/material.dart";
import 'newSpace/newSpace.dart';
import '../models/newSpaceNotifier.dart';
import "package:provider/provider.dart";
import "../widgets/layout.dart";
import "./newSpace/menu.dart";
import "./newSpace/content.dart";

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _NewReservationStructureState();
}

class _NewReservationStructureState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provides the NewSpace model to this widget tree
      create: (_) => NewSpaceNotifier(),
      child: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: NewSpace(),
      ),
    );
  }
}

import "package:flexwork/admin/newSpace/keyboardListener.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../models/floors.dart";

class NewSpace extends StatelessWidget {
  // state
  var floor = Floors.f10;
  NewSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewSpaceNotifier>(
      create: (context) => NewSpaceNotifier(floor),
      child: NewSpaceKeyboardListener());
  }
}
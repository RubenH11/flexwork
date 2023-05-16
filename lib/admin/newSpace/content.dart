import "package:flutter/material.dart";
import "../../models/floors.dart";
import "package:provider/provider.dart";
import "../../widgets/adminFloor.dart";
import '../../models/newSpaceNotifier.dart';

class NewSpaceContent extends StatelessWidget {
  final Floors floor;
  const NewSpaceContent({required this.floor, super.key});

  @override
  Widget build(BuildContext context) {
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);
    return Column(
      children: [
        AdminFloor(floor: Floors.f11),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Identifier")),
            Expanded(
              child: TextField(onChanged: (value) => newSpaceNotifier.setIdentifier(value),),
            ),
          ],
        )
      ],
    );
  }
}

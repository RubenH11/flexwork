import "package:flutter/material.dart";
import "../../models/floors.dart";
import "package:provider/provider.dart";
import "../../widgets/adminFloor.dart";
import '../../models/newSpaceNotifier.dart';

class NewSpaceContent extends StatelessWidget {
  final Floors floor;
  final bool isValid;
  const NewSpaceContent({required this.floor, required this.isValid, super.key});

  @override
  Widget build(BuildContext context) {
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);
    return Column(
      children: [
        AdminFloor(floor: floor, isValid: isValid),
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

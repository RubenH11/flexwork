import "package:flutter/material.dart";
import "../../models/floors.dart";
import "package:provider/provider.dart";
import '../../widgets/newSpaceFloor.dart';
import '../../models/newSpaceNotifier.dart';

class NewSpaceContent extends StatelessWidget {
  final bool isValid;
  const NewSpaceContent({required this.isValid, super.key});

  @override
  Widget build(BuildContext context) {
    print("build newSpace content");
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);
    return Column(
      children: [
        NewSpaceFloor(isValid: isValid),
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

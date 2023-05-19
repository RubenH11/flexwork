import "package:flexwork/widgets/newSpaceTextField.dart";
import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:provider/provider.dart";
import "dart:math" as math;

class NewSpaceMenuRotation extends StatelessWidget {
  NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  Function updateMenu;
  NewSpaceMenuRotation({
    required this.newSpace,
    required this.newSpaceFocusNode,
    required this.updateMenu,
    super.key,
  });

  String getAngle(NewSpaceNotifier newSpace) {
    return newSpace.getAngleDegrees().toString();
  }

  @override
  Widget build(BuildContext context) {
    final newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    print("build rotation");
    return Column(
      children: [
        Row(
          children: [
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(0);
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 0,
              text: "0\u00B0",
            ),
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(math.atan(4 / 18));
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 10,
              text: "12.52\u00B0",
            ),
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(math.atan(3 / 4));
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 15,
              text: "36.87\u00B0",
            ),
          ],
        ),
        Row(
          children: [
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(0.5 * math.pi);
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 0,
              text: "90\u00B0",
            ),
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(math.atan(4 / 18) + 0.5 * math.pi);
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 10,
              text: "12.52\u00B0",
            ),
            CustomTextButton(
              onPressed: () {
                newSpace.setAngleInRadians(math.atan(3 / 4) + 0.5 * math.pi);
                // updateController();
                updateMenu();
              },
              selected: newSpace.getAngleDegrees() == 15,
              text: "15\u00B0",
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Angle")),
            Expanded(
              child: NewSpaceTextField(
                inputCheck: (value) {
                  if (value == "") {
                    return newSpace.attemptSetAngleInDegrees(0);
                  }
                  return newSpace.attemptSetAngleInDegrees(value);
                },
                setOnRebuild: getAngle,
                onSubmit: (value) {
                  newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setAngleInDegrees(0);
                  }
                  return newSpace.setAngleInDegrees(double.parse(value));
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

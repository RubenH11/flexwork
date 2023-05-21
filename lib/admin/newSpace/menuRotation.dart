import "package:flexwork/widgets/newSpaceTextField.dart";
import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:provider/provider.dart";
import "dart:math" as math;

class NewSpaceMenuRotation extends StatelessWidget {
  NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  NewSpaceMenuRotation({
    required this.newSpace,
    required this.newSpaceFocusNode,
    super.key,
  });

  String getAngle(NewSpaceNotifier newSpace) {
    return newSpace.getAngleDegrees().toString();
  }

  @override
  Widget build(BuildContext context) {
    final newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    // print("build rotation");
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(0);
                },
                selected: newSpace.getAngleDegrees() > -0.00001 && newSpace.getAngleDegrees() < 0.00001,
                text: "0\u00B0",
              ),
            ),
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(math.atan(4 / 18));
                },
                selected: newSpace.getAngleDegrees() > 12.52 && newSpace.getAngleDegrees() < 12.53,
                text: "12.53\u00B0",
              ),
            ),
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(math.atan(3 / 4));
                },
                selected: newSpace.getAngleDegrees() > 36.86 && newSpace.getAngleDegrees() < 36.87,
                text: "36.87\u00B0",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(0.5 * math.pi);
                },
                selected: newSpace.getAngleDegrees() > 89.9999 && newSpace.getAngleDegrees() < 90.0001,
                text: "90\u00B0",
              ),
            ),
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(math.atan(4 / 18) + 0.5 * math.pi);
                },
                selected: newSpace.getAngleDegrees() > 102.52 && newSpace.getAngleDegrees() < 102.53,
                text: "102.53\u00B0",
              ),
            ),
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  newSpace.setAngleInRadians(math.atan(3 / 4) + 0.5 * math.pi);
                },
                selected: newSpace.getAngleDegrees() > 126.86 && newSpace.getAngleDegrees() < 126.87,
                text: "126.87\u00B0",
              ),
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

import "package:flexwork/widgets/newSpaceTextField.dart";
import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:provider/provider.dart";

// if controller.text = "" then do nothing
// handle from 2 to 1 number with cursor at 2

class NewSpaceMenuCoordinates extends StatelessWidget {
  FocusNode newSpaceFocusNode;
  NewSpaceMenuCoordinates({
    required this.newSpaceFocusNode,
    super.key,
  });

  String getX(NewSpaceNotifier newSpace) {
    return newSpace.getXCoordinate().toString();
  }

  String getY(NewSpaceNotifier newSpace) {
    return newSpace.getYCoordinate().toString();
  }

  @override
  Widget build(BuildContext context) {
    final newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);

    // print("build coords");
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 100, child: Text("Horizontal")),
            Expanded(
              child: NewSpaceTextField(
                inputCheck: (value) {
                  final yCoord = newSpace.getYCoordinate();
                  if (value == "") {
                    return newSpace.attemptSetCoordinate(0.0, yCoord);
                  }
                  return newSpace.attemptSetCoordinate(value, yCoord);
                },
                setOnRebuild: getX,
                onSubmit: (value) {
                  final yCoord = newSpace.getYCoordinate();
                  newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setCoordinate(0.0, yCoord);
                  }
                  return newSpace.setCoordinate(double.parse(value), yCoord);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Vertical")),
            Expanded(
              child: NewSpaceTextField(
                inputCheck: (value) {
                  final xCoord = newSpace.getXCoordinate();
                  if (value == "") {
                    return newSpace.attemptSetCoordinate(xCoord, 0.0);
                  }
                  return newSpace.attemptSetCoordinate(xCoord, value);
                },
                setOnRebuild: getY,
                onSubmit: (value) {
                  final xCoord = newSpace.getXCoordinate();

                  newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setCoordinate(xCoord, 0.0);
                  }
                  return newSpace.setCoordinate(xCoord, double.parse(value));
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

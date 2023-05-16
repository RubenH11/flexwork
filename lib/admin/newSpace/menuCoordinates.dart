import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:number_text_input_formatter/number_text_input_formatter.dart";
import "package:provider/provider.dart";

class NewSpaceMenuCoordinates extends StatefulWidget {
  //NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  NewSpaceMenuCoordinates({
    required this.newSpaceFocusNode,
    //required this.newSpace,
    super.key,
  });

  @override
  State<NewSpaceMenuCoordinates> createState() => _CoordinateInterfaceState();
}

class _CoordinateInterfaceState extends State<NewSpaceMenuCoordinates> {
  final horizontalController = TextEditingController();
  final verticalController = TextEditingController();
  var horizontalCursorOffset = 0;
  var verticalCursorOffset = 0;

  late NewSpaceNotifier newSpace;

  void setX() {
    final value = horizontalController.text;
    if (value == "") {
      newSpace.setCoordinate(x: 0);
    } else {
      newSpace.setCoordinate(x: double.parse(value));
    }
  }

  void setY() {
    final value = verticalController.text;
    if (value == "") {
      newSpace.setCoordinate(y: 0);
    } else {
      newSpace.setCoordinate(y: double.parse(value));
    }
  }

  void updateControllers() {
    verticalController.text = newSpace.getYCoordinate().toString();
    horizontalController.text = newSpace.getXCoordinate().toString();
  }

  void restoreCursorOffsets() {
    if (horizontalController.text.length >= horizontalCursorOffset) {
      horizontalController.selection = TextSelection.fromPosition(
          TextPosition(offset: horizontalCursorOffset));
    }
    else{
      horizontalController.selection = TextSelection.fromPosition(
          TextPosition(offset: horizontalCursorOffset-1));
    }
    if (verticalController.text.length >= verticalCursorOffset) {
      verticalController.selection = TextSelection.fromPosition(
          TextPosition(offset: verticalCursorOffset));
    }
    else{
      verticalController.selection = TextSelection.fromPosition(
          TextPosition(offset: verticalCursorOffset-1));
    }
  }

  @override
  void initState() {
    newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    horizontalController.text = newSpace.getXCoordinate().toString();
    verticalController.text = newSpace.getYCoordinate().toString();
    super.initState();
  }

  @override
  void dispose() {
    horizontalController.dispose();
    verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateControllers();
    // print("during build horizontalCursorOffset is $horizontalCursorOffset");
    restoreCursorOffsets();
    print("build coords");
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 100, child: Text("Horizontal")),
            Expanded(
              child: TextField(
                controller: horizontalController,
                onTap: () => horizontalCursorOffset =
                    horizontalController.selection.baseOffset,
                onChanged: (_) {
                  horizontalCursorOffset =
                      horizontalController.selection.baseOffset;
                  // print(
                  //     "chanhed horizontalCursorOffset to $horizontalCursorOffset");
                  setX();
                },
                onTapOutside: (event) =>
                    widget.newSpaceFocusNode.requestFocus(),
                inputFormatters: [
                  NumberTextInputFormatter(
                    integerDigits: 10,
                    maxValue: '100000.00',
                    decimalSeparator: '.',
                    groupDigits: 3,
                    groupSeparator: ' ',
                    allowNegative: false,
                    overrideDecimalPoint: true,
                    insertDecimalPoint: false,
                    insertDecimalDigits: false,
                  ),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Vertical")),
            Expanded(
              child: TextField(
                controller: verticalController,
                onTap: () => verticalCursorOffset =
                    verticalController.selection.baseOffset,
                onChanged: (_) {
                  verticalCursorOffset =
                      verticalController.selection.baseOffset;
                  print(
                      "chanhed horizontalCursorOffset to $horizontalCursorOffset");
                  setY();
                },
                onTapOutside: (event) =>
                    widget.newSpaceFocusNode.requestFocus(),
                inputFormatters: [
                  NumberTextInputFormatter(
                    integerDigits: 10,
                    maxValue: '100000.00',
                    decimalSeparator: '.',
                    groupDigits: 3,
                    groupSeparator: ' ',
                    allowNegative: false,
                    overrideDecimalPoint: true,
                    insertDecimalPoint: false,
                    insertDecimalDigits: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

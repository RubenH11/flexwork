import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:number_text_input_formatter/number_text_input_formatter.dart";
import "package:provider/provider.dart";
import "dart:math" as math;

class NewSpaceMenuRotation extends StatefulWidget {
  NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  Function updateMenu;
  NewSpaceMenuRotation({
    required this.newSpace,
    required this.newSpaceFocusNode,
    required this.updateMenu,
    super.key,
  });

  @override
  State<NewSpaceMenuRotation> createState() => _RotationInterfaceState();
}

class _RotationInterfaceState extends State<NewSpaceMenuRotation> {
  final angleController = TextEditingController();
  var angleCursorOffset = 0;
  late NewSpaceNotifier newSpace;

  void updateController() {
    angleController.text = widget.newSpace.getAngleDegrees().toString();
  }

  void restoreCursorOffset() {
    if (angleController.text.length >= angleCursorOffset) {
      angleController.selection = TextSelection.fromPosition(
          TextPosition(offset: angleCursorOffset));
    }
    else{
      angleController.selection = TextSelection.fromPosition(
          TextPosition(offset: angleCursorOffset-1));
    }
  }

  void setAngle() {
    final value = angleController.text;
    if (value == "") {
      newSpace.setAngle(0);
    } else {
      newSpace.setAngle(double.parse(value));
    }
  }

  @override
  void initState() {
    newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    angleController.text = widget.newSpace.getAngleDegrees().toString();
    super.initState();
  }

  @override
  void dispose() {
    angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateController();
    print("build rotation");
    return Column(
      children: [
        Row(
          children: [
            CustomTextButton(
              key: UniqueKey(),
              onPressed: () {
                widget.newSpace.setAngle(0);
                // updateController();
                widget.updateMenu();
              },
              selected: widget.newSpace.getAngleDegrees() == 0,
              text: "0 degrees",
            ),
            CustomTextButton(
              key: UniqueKey(),
              onPressed: () {
                widget.newSpace.setAngle(math.atan(4/18) * 180/math.pi);
                // updateController();
                widget.updateMenu();
              },
              selected: widget.newSpace.getAngleDegrees() == 10,
              text: "12.52 degrees",
            ),
            CustomTextButton(
              key: UniqueKey(),
              onPressed: () {
                widget.newSpace.setAngle(15);
                // updateController();
                widget.updateMenu();
              },
              selected: widget.newSpace.getAngleDegrees() == 15,
              text: "15 degrees",
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Angle")),
            Expanded(
              child: TextField(
                controller: angleController,
                onTap: () => angleCursorOffset =
                    angleController.selection.baseOffset,
                onChanged: (_) {
                  angleCursorOffset =
                      angleController.selection.baseOffset;
                  print(
                      "changed angleCursorOffset to $angleCursorOffset");
                  setAngle();
                },
                onTapOutside: (event) =>
                    widget.newSpaceFocusNode.requestFocus(),
                inputFormatters: [
                  NumberTextInputFormatter(
                    integerDigits: 10,
                    maxValue: '360.00',
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

import "package:flutter/material.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:number_text_input_formatter/number_text_input_formatter.dart";
import "package:provider/provider.dart";

class NewSpaceMenuSize extends StatefulWidget {
  NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  NewSpaceMenuSize({
    required this.newSpace,
    required this.newSpaceFocusNode,
    super.key,
  });

  @override
  State<NewSpaceMenuSize> createState() => _SizeButtonsState();
}

class _SizeButtonsState extends State<NewSpaceMenuSize> {
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final widthFocusNode = FocusNode();
  final heightFocusNode = FocusNode();
  var heightCursorOffset = 0;
  var widthCursorOffset = 0;

  late NewSpaceNotifier newSpace;

  void setHeight() {
    final value = heightController.text;
    if (value == "") {
      newSpace.setHeight(0);
    } else {
      newSpace.setHeight(double.parse(value));
    }
  }

  void setWidth() {
    final value = widthController.text;
    if (value == "") {
      newSpace.setWidth(0);
    } else {
      newSpace.setWidth(double.parse(value));
    }
  }

  void restoreCursorOffsets() {
    if (widthController.text.length >= widthCursorOffset) {
      widthController.selection =
          TextSelection.fromPosition(TextPosition(offset: widthCursorOffset));
    } else {
      widthController.selection = TextSelection.fromPosition(
          TextPosition(offset: widthCursorOffset - 1));
    }
    if (heightController.text.length >= heightCursorOffset) {
      heightController.selection =
          TextSelection.fromPosition(TextPosition(offset: heightCursorOffset));
    } else {
      heightController.selection = TextSelection.fromPosition(
          TextPosition(offset: heightCursorOffset - 1));
    }
  }

  void updateControllers() {
    heightController.text = newSpace.getHeight().toString();
    widthController.text = newSpace.getWidth().toString();
  }

  @override
  void initState() {
    newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    widthController.text = newSpace.getWidth().toString();
    heightController.text = newSpace.getHeight().toString();
    super.initState();
  }

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateControllers();
    restoreCursorOffsets();
    print("build size");
    return Column(
      children: [
        Row(
          children: [
            CustomTextButton(
                key: UniqueKey(),
                onPressed: () {
                  newSpace.setHeight(18);
                  newSpace.setWidth(12);
                  updateControllers();
                },
                selected:
                    newSpace.getHeight() == 18 && newSpace.getWidth() == 12,
                text: "small office"),
            CustomTextButton(
                key: UniqueKey(),
                onPressed: () {
                  newSpace.setHeight(18);
                  newSpace.setWidth(24);
                  updateControllers();
                },
                selected:
                    newSpace.getHeight() == 18 && newSpace.getWidth() == 24,
                text: "large office"),
            CustomTextButton(
                key: UniqueKey(),
                onPressed: () {
                  newSpace.setHeight(4);
                  newSpace.setWidth(6);
                  updateControllers();
                },
                selected: newSpace.getHeight() == 4 && newSpace.getWidth() == 6,
                text: "single desk"),
          ],
        ),
        Row(
          children: [
            CustomTextButton(
              onPressed: () {},
              selected: false,
              text: "1x2 desks",
            ),
            CustomTextButton(
              onPressed: () {},
              selected: false,
              text: "2x2 desks",
            ),
            CustomTextButton(
              onPressed: () {},
              selected: false,
              text: "2x3 desks",
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Height")),
            Expanded(
              child: TextField(
                controller: heightController,
                focusNode: heightFocusNode,
                onTap: () =>
                    heightCursorOffset = heightController.selection.baseOffset,
                onChanged: (_) {
                  heightCursorOffset = heightController.selection.baseOffset;
                  setHeight();
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
            SizedBox(width: 100, child: Text("Width")),
            Expanded(
              child: TextField(
                controller: widthController,
                focusNode: widthFocusNode,
                onTap: () =>
                    widthCursorOffset = widthController.selection.baseOffset,
                onChanged: (_) {
                  widthCursorOffset = widthController.selection.baseOffset;
                  setWidth();
                },
                onTapOutside: (event) =>
                    widget.newSpaceFocusNode.requestFocus(),
                inputFormatters: [
                  NumberTextInputFormatter(
                    integerDigits: 10,
                    maxValue: '1000.00',
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
        )
      ],
    );
  }
}

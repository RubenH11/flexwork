import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import '../../models/newSpaceNotifier.dart';
import "../../widgets/customTextButton.dart";
import "package:provider/provider.dart";
import "../../widgets/newSpaceTextField.dart";

class NewSpaceMenuSize extends StatefulWidget {
  NewSpaceNotifier newSpace;
  FocusNode newSpaceFocusNode;
  NewSpaceMenuSize({
    required this.newSpace,
    required this.newSpaceFocusNode,
    super.key,
  });

  @override
  State<NewSpaceMenuSize> createState() => _NewSpaceMenuSizeState();
}

class _NewSpaceMenuSizeState extends State<NewSpaceMenuSize> {
  String getHeight(NewSpaceNotifier newSpace) {
    return newSpace.getHeight().toString();
  }

  String getWidth(NewSpaceNotifier newSpace) {
    return newSpace.getWidth().toString();
  }

  @override
  Widget build(BuildContext context) {
    final newSpace = Provider.of<NewSpaceNotifier>(context);
    // print("build size");
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                onPressed: () {
                  print("set width throuw button");
                  newSpace.setHeight(18);
                  newSpace.setWidth(12);
                  // updateControllers();
                },
                selected: newSpace.getHeight() == 18 && newSpace.getWidth() == 12,
                text: "small office",
              ),
            ),
            Expanded(
              child: CustomTextButton(
                  onPressed: () {
                    print("set width throuw button");
                    newSpace.setHeight(18);
                    newSpace.setWidth(24);
                  },
                  selected:
                      newSpace.getHeight() == 18 && newSpace.getWidth() == 24,
                  text: "large office"),
            ),
            Expanded(
              child: CustomTextButton(
                  onPressed: () {
                    print("set width throuw button");
                    newSpace.setHeight(6);
                    newSpace.setWidth(8);
                  },
                  selected: newSpace.getHeight() == 8 && newSpace.getWidth() == 6,
                  text: "single desk"),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Height")),
            Expanded(
              child: NewSpaceTextField(
                inputCheck: (value) {
                  if (value == "") {
                    return newSpace.attemptSetHeight(0.0);
                  }
                  return newSpace.attemptSetHeight(value);
                },
                setOnRebuild: getHeight,
                onSubmit: (value) {
                  widget.newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setHeight(0.0);
                  }
                  return newSpace.setHeight(double.parse(value));
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Width")),
            Expanded(
              child: NewSpaceTextField(
                inputCheck: (value) {
                  if (value == "") {
                    return newSpace.attemptSetWidth(0.0);
                  }
                  return newSpace.attemptSetWidth(value);
                },
                setOnRebuild: getWidth,
                onSubmit: (value) {
                  widget.newSpaceFocusNode.requestFocus();
                  print("set width in size textfield");
                  if (value == "") {
                    return newSpace.setWidth(0.0);
                  }
                  return newSpace.setWidth(double.parse(value));
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

class NewSpaceCustomTextButton extends StatelessWidget {
  final Function onPressed;
  final bool Function() selected;
  final String text;
  const NewSpaceCustomTextButton({
    required this.onPressed,
    required this.selected,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<NewSpaceNotifier>(context);
    print("rebuild button that is ${selected()}");

    return CustomTextButton(
      onPressed: onPressed,
      selected: selected(),
      text: text,
    );
  }
}

import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import "package:flexwork/widgets/newSpaceTextField.dart";
import "package:provider/provider.dart";

import '../../widgets/menuItem.dart';
import "package:flutter/material.dart";
import "../../models/newSpaceNotifier.dart";

class NewSpaceMenuInfiniteCoordinates extends StatelessWidget {
  final FocusNode newSpaceFocusNode;
  const NewSpaceMenuInfiniteCoordinates({
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
    final newSpaceNotif = Provider.of<NewSpaceNotifier>(context);
    final coords = newSpaceNotif.getCoords();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: 
            Column(
              children: [
                _CoordinateFields(
                    newSpace: newSpaceNotif,
                    newSpaceFocusNode: newSpaceFocusNode,
                    numOfCoord: 0),
                _CoordinateFields(
                    newSpace: newSpaceNotif,
                    newSpaceFocusNode: newSpaceFocusNode,
                    numOfCoord: 1),
                _CoordinateFields(
                    newSpace: newSpaceNotif,
                    newSpaceFocusNode: newSpaceFocusNode,
                    numOfCoord: 2),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final numOfCoords = index + 3;
                    return _CoordinateFields(
                      newSpace: newSpaceNotif,
                      newSpaceFocusNode: newSpaceFocusNode,
                      numOfCoord: numOfCoords,
                      allowDelete: true,
                    );
                  },
                  itemCount: coords.length - 3,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    newSpaceNotif.addCoordinateFromLast();
                  },
                  selected: true,
                  active: true,
                  text: "Add new coordinate",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CoordinateFields extends StatelessWidget {
  const _CoordinateFields({
    super.key,
    required this.newSpace,
    required this.newSpaceFocusNode,
    required this.numOfCoord,
    this.allowDelete = false,
  });

  final NewSpaceNotifier newSpace;
  final FocusNode newSpaceFocusNode;
  final int numOfCoord;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);

    return MenuItem(
      title: "Coordinate ${numOfCoord + 1}",
      icon: Icon(Icons.data_array),
      trailing: allowDelete
          ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                newSpaceNotifier.deleteCoordinate(numOfCoord);
              },
              color: Theme.of(context).colorScheme.error,
              // style: ButtonStyle(splashFactory: NoSplash.splashFactory, ),
              splashRadius: 0.1,
            )
          : null,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20, child: Text("X")),
              Expanded(
                  child: NewSpaceTextField(
                inputCheck: (value) {
                  final yCoord =
                      newSpace.getYCoordinate(numOfCoord: numOfCoord);
                  if (value == "") {
                    return newSpace.attemptSetOneCoord(
                        x: 0.0, y: yCoord, numOfCoord: numOfCoord);
                  }
                  return newSpace.attemptSetOneCoord(
                      x: value, y: yCoord, numOfCoord: numOfCoord);
                },
                setOnRebuild: (newSpace) {
                  return newSpace
                      .getXCoordinate(numOfCoord: numOfCoord)
                      .toString();
                },
                onSubmit: (value) {
                  final yCoord =
                      newSpace.getYCoordinate(numOfCoord: numOfCoord);
                  newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setOneCoord(
                        x: 0.0, y: yCoord, numOfCoord: numOfCoord);
                  }
                  return newSpace.setOneCoord(
                      x: double.parse(value),
                      y: yCoord,
                      numOfCoord: numOfCoord);
                },
              )),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20, child: Text("Y")),
              Expanded(
                  child: NewSpaceTextField(
                inputCheck: (value) {
                  final xCoord =
                      newSpace.getXCoordinate(numOfCoord: numOfCoord);
                  if (value == "") {
                    return newSpace.attemptSetOneCoord(
                        x: xCoord, y: 0.0, numOfCoord: numOfCoord);
                  }
                  return newSpace.attemptSetOneCoord(
                      x: xCoord, y: value, numOfCoord: numOfCoord);
                },
                setOnRebuild: (newSpace) {
                  return newSpace
                      .getYCoordinate(numOfCoord: numOfCoord)
                      .toString();
                },
                onSubmit: (value) {
                  final xCoord =
                      newSpace.getXCoordinate(numOfCoord: numOfCoord);

                  newSpaceFocusNode.requestFocus();
                  if (value == "") {
                    return newSpace.setOneCoord(
                        x: xCoord, y: 0.0, numOfCoord: numOfCoord);
                  }
                  return newSpace.setOneCoord(
                      x: xCoord,
                      y: double.parse(value),
                      numOfCoord: numOfCoord);
                },
              )),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

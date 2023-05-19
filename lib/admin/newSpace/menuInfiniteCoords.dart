import "package:flexwork/widgets/newSpaceTextField.dart";

import "../../widgets/menu_item.dart";
import "package:flutter/material.dart";
import "../../models/newSpaceNotifier.dart";

class NewSpaceMenuInfiniteCoordinates extends StatelessWidget {
  final NewSpaceNotifier newSpace;
  final FocusNode newSpaceFocusNode;
  const NewSpaceMenuInfiniteCoordinates({
    required this.newSpace,
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
    final coords = newSpace.getCoords();

    return Expanded(
        child: ListView.builder(
      itemBuilder: (_, index) {
        return MenuItem(
          icon: Icon(Icons.data_array),
          title: "Coordinate ${index + 1}",
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 20, child: Text("X")),
                  Expanded(
                      child: NewSpaceTextField(
                    inputCheck: (value) {
                      final yCoord = newSpace.getYCoordinate(numOfCoord: index);
                      if (value == "") {
                        return newSpace.attemptSetOneCoord(x: 0.0, y: yCoord, numOfCoord: index);
                      }
                      return newSpace.attemptSetOneCoord(x: value, y: yCoord, numOfCoord: index);
                    },
                    setOnRebuild: (newSpace) {
                      return newSpace.getXCoordinate(numOfCoord: index).toString();
                    },
                    onSubmit: (value) {
                      final yCoord = newSpace.getYCoordinate(numOfCoord: index);
                      newSpaceFocusNode.requestFocus();
                      if (value == "") {
                        return newSpace.setOneCoord(x: 0.0, y: yCoord, numOfCoord: index);
                      }
                      return newSpace.setOneCoord(x: double.parse(value), y: yCoord, numOfCoord: index);
                    },
                  )),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20, child: Text("Y")),
                  Expanded(
                      child: NewSpaceTextField(
                    inputCheck: (value) {
                      final xCoord = newSpace.getXCoordinate(numOfCoord: index);
                      if (value == "") {
                        return newSpace.attemptSetOneCoord(x: xCoord, y: 0.0, numOfCoord: index);
                      }
                      return newSpace.attemptSetOneCoord(x: xCoord, y: value, numOfCoord: index);
                    },
                    setOnRebuild: (newSpace){
                      return newSpace.getYCoordinate(numOfCoord: index).toString();
                    },
                    onSubmit: (value) {
                      final xCoord = newSpace.getXCoordinate(numOfCoord: index);

                      newSpaceFocusNode.requestFocus();
                      if (value == "") {
                        return newSpace.setOneCoord(x: xCoord, y: 0.0, numOfCoord: index);
                      }
                      return newSpace.setOneCoord(x: xCoord, y: double.parse(value), numOfCoord: index);
                    },
                  )),
                ],
              )
            ],
          ),
        );
      },
      itemCount: coords.length,
    ));
  }
}

// class CoordinateTextField extends StatelessWidget {
//   final String title;
//   // final _controller = TextEditingController();
//   final double value;
//   CoordinateTextField({required this.title, required this.value, super.key});

//   @override
//   Widget build(BuildContext context) {
//     _controller.text = value.toString();
//     return Row(
//       children: [
//         SizedBox(
//           width: 20,
//           child: Text(title),
//         ),
//         Expanded(
//             child: NewSpaceTextField(
//                 setOnRebuild: setOnRebuild,
//                 onSubmit: onSubmit,
//                 inputCheck: inputCheck)),
//       ],
//     );
//   }
// }

import "package:firebase_core/firebase_core.dart";
import "package:flexwork/admin/newSpace/menuCoordinates.dart";
import "package:flexwork/admin/newSpace/menuInfiniteCoords.dart";
import "package:flexwork/admin/newSpace/menuRotation.dart";
import "package:flexwork/admin/newSpace/menuSize.dart";
import "package:flexwork/helpers/firebaseService.dart";
import 'package:flexwork/models/newSpaceNotifier.dart';
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flutter/material.dart";
import "../../widgets/menu_item.dart";
import "package:provider/provider.dart";
import "../../models/floors.dart";

class NewSpaceDefaultMenu extends StatelessWidget {
  final FocusNode newSpaceFocusNode;
  final bool isValid;
  const NewSpaceDefaultMenu({
    required this.newSpaceFocusNode,
    required this.isValid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("rebuild whole menu");
    final newSpace = Provider.of<NewSpaceNotifier>(context);

    void addRoom() async {
      print("add");
      final identifier = newSpace.getIdentifier();
      final space = newSpace.getPath();

      await FirebaseService().addNewWorkspaceToDB(identifier, newSpace);
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              MenuItem(
                icon: Icon(Icons.photo_size_select_small),
                title: "Size",
                child: NewSpaceMenuSize(
                  newSpace: newSpace,
                  newSpaceFocusNode: newSpaceFocusNode,
                ),
              ),
              const Divider(),
              MenuItem(
                icon: Icon(Icons.compare_arrows),
                title: "Coordinates",
                child:
                NewSpaceMenuCoordinates(
                  newSpaceFocusNode: newSpaceFocusNode,
                ),
              ),
              const Divider(),
              MenuItem(
                icon: Icon(Icons.rotate_90_degrees_ccw),
                title: "Rotation",
                child: NewSpaceMenuRotation(
                  newSpace: newSpace,
                  newSpaceFocusNode: newSpaceFocusNode,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () {
                  print("cancel");
                },
                active: true,
                selected: false,
                text: "cancel",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomElevatedButton(
                onPressed: addRoom,
                active: isValid,
                selected: true,
                text: "add",
              ),
            ),
          ],
        )
      ],
    );
  }
}

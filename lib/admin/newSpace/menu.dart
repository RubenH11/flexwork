
import "package:flexwork/admin/newSpace/menuCoordinates.dart";
import "package:flexwork/admin/newSpace/menuRotation.dart";
import "package:flexwork/admin/newSpace/menuSize.dart";
import "package:flexwork/helpers/firebase.dart";
import 'package:flexwork/models/newSpaceNotifier.dart';
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flutter/material.dart";
import "../../widgets/menu_item.dart";
import "package:provider/provider.dart";
import "../../models/floors.dart";

class NewSpaceMenu extends StatelessWidget {
  FocusNode newSpaceFocusNode;
  Function updateMenu;
  Floors floor;
  NewSpaceMenu({
    required this.newSpaceFocusNode,
    required this.updateMenu,
    required this.floor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("rebuild whole menu");
    final newSpace = Provider.of<NewSpaceNotifier>(context);

    void addRoom() {
      print("add");
      final identifier = newSpace.getIdentifier();
      final space = newSpace.getPath();
      // final service = FirebaseService();
      // service.addSpace(identifier, space);
    }

    return Column(
      children: [
        MenuItem(
            icon: Icon(Icons.photo_size_select_small),
            title: "Size",
            child: NewSpaceMenuSize(
              newSpace: newSpace,
              newSpaceFocusNode: newSpaceFocusNode,
            )),
        const Divider(),
        MenuItem(
          // key: UniqueKey(),
          icon: Icon(Icons.compare_arrows),
          title: "Coordinates",
          child: NewSpaceMenuCoordinates(
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
            updateMenu: updateMenu,
          ),
        ),
        const Spacer(),
        const Divider(),
        Row(
          children: [
            CustomElevatedButton(
              onPressed: () {print("tt");},
              active: true,
              text: "cancel",
            ),
            SizedBox(
              width: 10,
            ),
            CustomElevatedButton(
              onPressed: (){
                print("test");
                addRoom();
              },
              active: newSpace.isValid(floor),
              text: "add",
            ),
          ],
        )
      ],
    );
  }
}

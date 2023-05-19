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

class NewSpaceMenu extends StatefulWidget {
  final FocusNode newSpaceFocusNode;
  final Function updateMenu;
  final bool isValid;
  const NewSpaceMenu({
    required this.newSpaceFocusNode,
    required this.updateMenu,
    required this.isValid,
    super.key,
  });

  @override
  State<NewSpaceMenu> createState() => _NewSpaceMenuState();
}

class _NewSpaceMenuState extends State<NewSpaceMenu> {
  var isRectangularSpace = true;

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
        Row(
          children: [
            CustomElevatedButton(
              onPressed: () => setState(() => isRectangularSpace = true),
              active: !isRectangularSpace,
              selected: isRectangularSpace,
              text: "rectangular",
            ),
            CustomElevatedButton(
              onPressed: () => setState(() => isRectangularSpace = false),
              active: isRectangularSpace,
              selected: !isRectangularSpace,
              text: "advanced",
            ),
          ],
        ),
        Divider(),
        Expanded(
          child: isRectangularSpace
              ? Column(
                  children: [
                    MenuItem(
                        icon: Icon(Icons.photo_size_select_small),
                        title: "Size",
                        child: NewSpaceMenuSize(
                          newSpace: newSpace,
                          newSpaceFocusNode: widget.newSpaceFocusNode,
                        )),
                    const Divider(),
                    MenuItem(
                      // key: UniqueKey(),
                      icon: Icon(Icons.compare_arrows),
                      title: "Coordinates",
                      child: NewSpaceMenuCoordinates(
                        newSpaceFocusNode: widget.newSpaceFocusNode,
                      ),
                    ),
                    const Divider(),
                    MenuItem(
                      icon: Icon(Icons.rotate_90_degrees_ccw),
                      title: "Rotation",
                      child: NewSpaceMenuRotation(
                        newSpace: newSpace,
                        newSpaceFocusNode: widget.newSpaceFocusNode,
                        updateMenu: widget.updateMenu,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    NewSpaceMenuInfiniteCoordinates(
                      newSpace: newSpace,
                      newSpaceFocusNode: widget.newSpaceFocusNode,
                    ),
                    const Divider(),
                  ],
                ),
        ),
        const Divider(),
        Row(
          children: [
            CustomElevatedButton(
              onPressed: () {
                print("cancel");
              },
              active: true,
              selected: false,
              text: "cancel",
            ),
            SizedBox(
              width: 10,
            ),
            CustomElevatedButton(
              onPressed: addRoom,
              active: widget.isValid,
              selected: true,
              text: "add",
            ),
          ],
        )
      ],
    );
  }
}

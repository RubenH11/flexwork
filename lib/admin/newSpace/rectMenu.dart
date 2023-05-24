import "package:firebase_core/firebase_core.dart";
import "package:flexwork/admin/newSpace/menuCoordinates.dart";
import "package:flexwork/admin/newSpace/menuInfiniteCoords.dart";
import "package:flexwork/admin/newSpace/menuRotation.dart";
import "package:flexwork/admin/newSpace/menuSize.dart";
import "package:flexwork/helpers/firebaseService.dart";
import 'package:flexwork/models/newSpaceNotifier.dart';
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flutter/material.dart";
import '../../widgets/menuItem.dart';
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
    final newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);

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
      ],
    );
  }
}

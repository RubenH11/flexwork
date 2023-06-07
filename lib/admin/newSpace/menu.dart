import 'package:flexwork/admin/newSpace/advancedMenu.dart';
import 'package:flexwork/admin/newSpace/rectMenu.dart';
import 'package:flexwork/database/database.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newSpaceNotifier.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum NewSpaceMethods {
  rectangular,
  advanced,
}

class AdminNewSpaceMenu extends StatefulWidget {
  final List<Workspace> workspaces;
  final void Function(bool) setNewSpace;
  final Floors floor;
  final FocusNode newSpaceFocusNode;
  const AdminNewSpaceMenu({
    super.key,
    required this.workspaces,
    required this.setNewSpace,
    required this.floor,
    required this.newSpaceFocusNode,
  });

  @override
  State<AdminNewSpaceMenu> createState() => _AdminNewSpaceMenuState();
}

class _AdminNewSpaceMenuState extends State<AdminNewSpaceMenu> {
  NewSpaceMethods currentMethod = NewSpaceMethods.rectangular;

  void setMethod(NewSpaceMethods method) {
    setState(() {
      currentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () => setMethod(NewSpaceMethods.rectangular),
                active: currentMethod == NewSpaceMethods.advanced,
                selected: currentMethod == NewSpaceMethods.rectangular,
                text: "Rectangular",
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                onPressed: () => setMethod(NewSpaceMethods.advanced),
                active: currentMethod == NewSpaceMethods.rectangular,
                selected: currentMethod == NewSpaceMethods.advanced,
                text: "Advanced",
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: currentMethod == NewSpaceMethods.rectangular
                ? AdminNewSpaceRectMenu(
                    newSpaceFocusNode: widget.newSpaceFocusNode)
                : AdminNewSpaceAdvancedMenu(
                    newSpaceFocusNode: widget.newSpaceFocusNode),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () => widget.setNewSpace(false),
                active: true,
                selected: false,
                text: "cancel",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Consumer<NewSpaceNotifier>(
                builder: (context, newSpaceNotif, _) {
                  return CustomElevatedButton(
                    onPressed: () async {
                      await DatabaseFunctions.addWorkspace(newSpaceNotif);
                      widget.setNewSpace(false);
                    },
                    active:
                        newSpaceNotif.isValid(widget.floor, widget.workspaces),
                    selected: true,
                    text: "add",
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

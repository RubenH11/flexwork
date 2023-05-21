import "package:flexwork/admin/content.dart";
import "package:flexwork/admin/menu.dart";
import "package:flexwork/admin/newSpace/keyboardListener.dart";
import "package:flexwork/admin/newSpace/menuAbove.dart";
import "package:flexwork/admin/newSpace/menuInfiniteCoords.dart";
import "package:flexwork/admin/newSpace/rectMenu.dart";
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/layout.dart";
import "package:flexwork/widgets/menu_item.dart";
import 'package:flexwork/widgets/floor.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/customTextButton.dart";
import '../models/workspaceSelectionNotifier.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _NewReservationStructureState();
}

class _NewReservationStructureState extends State<Admin> {
  final LABEL_INDENT = 10.0;
  var _floor = Floors.f9;
  var newSpaceInterface = false;
  var advancedMenu = false;
  final newSpaceFocusNode = FocusNode();

  void setFloor(Floors floor) {
    setState(() {
      _floor = floor;
    });
  }

  void setNewSpaceInterface() {
    setState(() {
      newSpaceInterface = true;
    });
  }

  void setAdvancedMenu() {
    setState(() {
      advancedMenu = true;
    });
  }

  void setDefaultMenu() {
    setState(() {
      advancedMenu = false;
    });
  }

  @override
  void dispose() {
    newSpaceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "rebuild admin with floor ${_floor.name} and advanced to $advancedMenu");
    return newSpaceInterface
        ? ChangeNotifierProvider<NewSpaceNotifier>(
            create: (_) => NewSpaceNotifier(_floor),
            builder: (ctx, _) {
              final newSpace = Provider.of<NewSpaceNotifier>(ctx);
              return Layout(
                  aboveMenu: NewSpaceMenuAbove(
                    advancedMenu: advancedMenu,
                    setAdvancedMenu: setAdvancedMenu,
                    setDefaultMenu: setDefaultMenu,
                  ),
                  menu: advancedMenu
                      ? NewSpaceMenuInfiniteCoordinates(
                          newSpace: newSpace,
                          newSpaceFocusNode: newSpaceFocusNode,
                        )
                      : NewSpaceDefaultMenu(
                          newSpaceFocusNode: newSpaceFocusNode,
                          isValid: newSpace.isValid(_floor)),
                  content: NewSpaceKeyboardListener(
                      floor: _floor, focusNode: newSpaceFocusNode));
            },
          )
        : Layout(
            menu: AdminMenu(
                floor: _floor,
                setFloor: setFloor,
                setNewSpaceInterface: () {
                  setNewSpaceInterface();
                  // debugDumpRenderTree();
                }),
            content: ChangeNotifierProvider<WorkspaceSelectionNotifier>(
              create: (context) => WorkspaceSelectionNotifier(),
              child: AdminContent(floor: _floor),
            ),
          );
  }
}

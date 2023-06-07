import 'package:flexwork/admin/floorsContent.dart';
import 'package:flexwork/admin/floorsMenu.dart';
import 'package:flexwork/admin/newSpace/keyboardListener.dart';
import 'package:flexwork/admin/newSpace/menu.dart';
import 'package:flexwork/database/database.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newSpaceNotifier.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminFloors extends StatefulWidget {
  const AdminFloors({super.key});

  @override
  State<AdminFloors> createState() => _AdminFloorsState();
}

class _AdminFloorsState extends State<AdminFloors> {
  Floors floor = Floors.f9;

  void setFloor(Floors floor) {
    setState(() {
      this.floor = floor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlexworkFutureBuilder(
        future: DatabaseFunctions.getWorkspaces(floor),
        builder: (workspaces) {
          return AdminSelectedFloor(
              setFloor: setFloor, floor: floor, workspaces: workspaces);
        });
  }
}

class AdminSelectedFloor extends StatefulWidget {
  final void Function(Floors) setFloor;
  final Floors floor;
  final List<Workspace> workspaces;
  const AdminSelectedFloor({
    super.key,
    required this.setFloor,
    required this.floor,
    required this.workspaces,
  });

  @override
  State<AdminSelectedFloor> createState() => _AdminSelectedFloorState();
}

class _AdminSelectedFloorState extends State<AdminSelectedFloor> {
  Workspace? selectedWorkspace;
  var newSpace = false;

  void setWorkspace(Workspace? workspace) {
    setState(() {
      selectedWorkspace = workspace;
    });
  }

  void setNewSpace(bool set) {
    setState(() {
      newSpace = set;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return ChangeNotifierProvider(
      create: (_) {
        if (selectedWorkspace == null) {
          return NewSpaceNotifier(floor: widget.floor);
        }
        return NewSpaceNotifier(
          floor: widget.floor,
          coordinates: selectedWorkspace!.getCoords(),
        );
      },
      child: Row(
        children: [
          SizedBox(
            width: 350,
            child: newSpace
                ? AdminNewSpaceMenu(
                    workspaces: widget.workspaces,
                    setNewSpace: setNewSpace,
                    floor: widget.floor,
                    newSpaceFocusNode: focusNode,
                  )
                : AdminFloorsMenu(
                    floor: widget.floor,
                    selectFloor: widget.setFloor,
                    selectWorkspace: setWorkspace,
                    workspace: selectedWorkspace,
                    setNewSpace: setNewSpace,
                  ),
          ),
          VerticalDivider(),
          Expanded(
            child: newSpace
                ? AdminNewSpaceContent(
                    floor: widget.floor,
                    focusNode: focusNode,
                    workspaces: widget.workspaces,
                  )
                : AdminFloorsContent(
                    floor: widget.floor,
                    selectFloor: widget.setFloor,
                    selectWorkspace: setWorkspace,
                    workspace: selectedWorkspace,
                  ),
          ),
        ],
      ),
    );
  }
}
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/editWorkspace.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/workspaceSelectionNotifier.dart";
import "../widgets/floor.dart";

class AdminContent extends StatelessWidget {
  final Floors floor;
  final Workspace? selectedWorkspace;
  final Function(Workspace?) setSelectedWorkspace;
  const AdminContent({required this.floor, required this.selectedWorkspace, required this.setSelectedWorkspace, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Floor(
            floor: floor,
            selectedWorkspace: selectedWorkspace,
            setSelectedWorkspace: setSelectedWorkspace,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 3,
          child: selectedWorkspace == null ? SizedBox() : EditWorkspace(
            selectedWorkspace: selectedWorkspace!,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

import "package:flexwork/models/workspace.dart";
import "package:flexwork/models/workspaceSelectionNotifier.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import "package:flexwork/widgets/menu_item.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/floors.dart";

class AdminMenu extends StatelessWidget {
  final Floors floor;
  final Function(Floors) setFloor;
  final Function setNewSpaceInterface;
  final Workspace? selectedWorkspace;
  final Function(Workspace?) setSelectedWorkspace;
  const AdminMenu(
      {required this.floor,
      required this.setFloor,
      required this.setNewSpaceInterface,
      this.selectedWorkspace,
      required this.setSelectedWorkspace,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          icon: Icon(Icons.reorder),
          title: "Floors",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FloorButton("Floor 12", () {
                if (floor != Floors.f12) {
                  setSelectedWorkspace(null);
                }
                setFloor(Floors.f12);
              }, floor == Floors.f12),
              _FloorButton("Floor 11", () {
                if (floor != Floors.f11) {
                  setSelectedWorkspace(null);
                }
                setFloor(Floors.f11);
              }, floor == Floors.f11),
              _FloorButton("Floor 10", () {
                if (floor != Floors.f10) {
                  setSelectedWorkspace(null);
                }
                setFloor(Floors.f10);
              }, floor == Floors.f10),
              _FloorButton("Floor 9", () {
                if (floor != Floors.f9) {
                  setSelectedWorkspace(null);
                }
                setFloor(Floors.f9);
              }, floor == Floors.f9),
            ],
          ),
        ),
        Divider(),
        CustomElevatedButton(
          onPressed: setNewSpaceInterface,
          active: true,
          selected: true,
          text: "Add a new workspace",
        ),
        Spacer(),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () {},
                active: selectedWorkspace != null,
                selected: true,
                text: "Edit",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CustomElevatedButton(
                onPressed: () {},
                active: selectedWorkspace != null,
                selected: true,
                text: "Delete",
                selectedColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _FloorButton extends StatelessWidget {
  final String label;
  final Function() setFloor;
  final bool isSelected;
  const _FloorButton(this.label, this.setFloor, this.isSelected, {super.key});

  final LABEL_INDENT = 10.0;

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      alignLeft: true,
      text: label,
      selected: isSelected,
      onPressed: () {
        if (!isSelected) {
          setFloor();
        }
      },
    );
  }
}

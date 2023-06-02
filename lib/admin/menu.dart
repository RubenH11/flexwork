import "package:flexwork/admin/admin.dart";
import 'package:flexwork/database/firebaseService.dart';
import "package:flexwork/models/adminState.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/models/workspaceSelectionNotifier.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/floors.dart";

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    return Column(
      children: [
        MenuItem(
          icon: Icon(Icons.reorder),
          title: "Floors",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FloorButton("Floor 12", () {
                if (adminState.getFloor() != Floors.f12) {
                  adminState.selectWorkspace(null);
                }
                adminState.setFloor(Floors.f12);
              }, adminState.getFloor() == Floors.f12),
              _FloorButton("Floor 11", () {
                if (adminState.getFloor() != Floors.f11) {
                  adminState.selectWorkspace(null);
                }
                adminState.setFloor(Floors.f11);
              }, adminState.getFloor() == Floors.f11),
              _FloorButton("Floor 10", () {
                if (adminState.getFloor() != Floors.f10) {
                  adminState.selectWorkspace(null);
                }
                adminState.setFloor(Floors.f10);
              }, adminState.getFloor() == Floors.f10),
              _FloorButton("Floor 9", () {
                if (adminState.getFloor() != Floors.f9) {
                  adminState.selectWorkspace(null);
                }
                adminState.setFloor(Floors.f9);
              }, adminState.getFloor() == Floors.f9),
            ],
          ),
        ),
        Divider(),
        CustomElevatedButton(
          onPressed: (){
            adminState.setOpenPage(AdminPages.newSpaceRect);
          },
          active: true,
          selected: true,
          text: "Add a new workspace",
        ),
        Spacer(),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () async {
                  adminState.selectWorkspace(null);
                  await FirebaseService().workspaces.delete(adminState.getSelectedWorkspace()!);
                },
                active: adminState.getSelectedWorkspace() != null,
                selected: true,
                text: "Delete",
                selectedColor: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomElevatedButton(
                onPressed: () async {
                  try {
                    adminState.selectWorkspace(null);
                    print("presed confirm");
                    await FirebaseService()
                        .workspaces
                        .update(adminState.getSelectedWorkspace()!);
                    print("end presed confirm");
                    showBottomSheetWithTimer(context, "Updates succesfully",
                        Colors.green, Colors.white);
                  } catch (error) {
                    showBottomSheetWithTimer(
                        context,
                        "Something went wrong: $error",
                        Theme.of(context).colorScheme.error,
                        Theme.of(context).colorScheme.onError);
                  }
                },
                active: adminState.getSelectedWorkspace() != null,
                selected: true,
                text: "Confirm edit",
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

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      textAlign: TextAlign.left,
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

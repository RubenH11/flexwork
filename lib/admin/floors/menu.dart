import 'package:flexwork/helpers/database.dart';
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class AdminFloorsMenu extends StatelessWidget {
  final Floors floor;
  final Workspace? workspace;
  final void Function(Workspace?) selectWorkspace;
  final void Function(Floors) selectFloor;
  final void Function(bool) setNewSpace;
  final void Function() updatedLegend;
  final Map<String, Color> legend;
  const AdminFloorsMenu({
    required this.floor,
    required this.selectFloor,
    required this.selectWorkspace,
    required this.workspace,
    required this.setNewSpace,
    required this.legend,
    required this.updatedLegend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      width: 200,
      child: Column(
        children: [
          MenuItem(
            icon: Icon(Icons.reorder),
            title: "Floors",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FloorButton("Floor 12", () {
                  if (floor != Floors.f12) {
                    selectWorkspace(null);
                  }
                  selectFloor(Floors.f12);
                }, floor == Floors.f12),
                _FloorButton("Floor 11", () {
                  if (floor != Floors.f11) {
                    selectWorkspace(null);
                  }
                  selectFloor(Floors.f11);
                }, floor == Floors.f11),
                _FloorButton("Floor 10", () {
                  if (floor != Floors.f10) {
                    selectWorkspace(null);
                  }
                  selectFloor(Floors.f10);
                }, floor == Floors.f10),
                _FloorButton("Floor 9", () {
                  if (floor != Floors.f9) {
                    selectWorkspace(null);
                  }
                  selectFloor(Floors.f9);
                }, floor == Floors.f9),
              ],
            ),
          ),
          Divider(),
          CustomElevatedButton(
            onPressed: () => setNewSpace(true),
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
                    selectWorkspace(null);
                    final success = await DatabaseFunctions.deleteWorkspace(
                        workspace!.getId());
                    if (success) {
                      showBottomSheetWithTimer(
                          context, "Deleted workspace sucessfully",
                          succes: true);
                    } else {
                      showBottomSheetWithTimer(
                          context, "Could not delete workspace",
                          error: true);
                    }
                  },
                  active: workspace != null,
                  selected: workspace != null,
                  text: "Delete",
                  selectedColor: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: workspace == null
                    ? CustomElevatedButton(
                        onPressed: () {},
                        active: false,
                        selected: false,
                        text: "Confirm edit",
                      )
                    : ChangeNotifierProvider.value(
                        value: workspace,
                        builder: (context, _) {
                          final workspace = Provider.of<Workspace>(context);
                          print("rebuilding confirm button");
                          return CustomElevatedButton(
                            onPressed: () async {
                              final succes =
                                  await DatabaseFunctions.updateWorkspace(
                                      workspace);
                              if (succes) {
                                showBottomSheetWithTimer(
                                  context,
                                  "Updated succesfully",
                                  succes: true,
                                );
                                selectWorkspace(null);
                              } else {
                                showBottomSheetWithTimer(
                                  context,
                                  "Could not update workspace",
                                  error: true,
                                );
                              }
                            },
                            active: workspace == null
                                ? false
                                : workspace.hasChanged(),
                            selected: workspace != null,
                            text: "Confirm edit",
                          );
                        },
                      ),
              ),
            ],
          )
        ],
      ),
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
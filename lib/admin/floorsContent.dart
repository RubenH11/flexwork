import "package:flexwork/models/floors.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/editWorkspace.dart";
import "package:flutter/material.dart";
import "../widgets/floor.dart";

class AdminFloorsContent extends StatelessWidget {
  final Floors floor;
  final Workspace? workspace;
  final void Function(Workspace?) selectWorkspace;
  final void Function(Floors) selectFloor;
  final Map<String, Color> legend;
  final void Function() updatedLegend;
  const AdminFloorsContent({
    required this.floor,
    required this.selectFloor,
    required this.selectWorkspace,
    required this.workspace,
    required this.legend,
    required this.updatedLegend,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    print("|||| build AdminFloorsContent ||||");
    print("     with selected workspace: ${workspace}");
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Floor(
              legend: legend,
              floor: floor,
              selectedWorkspace: workspace,
              setSelectedWorkspace: (workspace) {
                selectWorkspace(workspace);
              },
              blockedWorkspaceIds: const [],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: workspace != null ? EditWorkspace(selectedWorkspace: workspace!, legend: legend, updatedLegend: updatedLegend,) : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

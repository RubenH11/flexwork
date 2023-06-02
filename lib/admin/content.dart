import "package:flexwork/models/adminState.dart";
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/editWorkspace.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/workspaceSelectionNotifier.dart";
import "../widgets/floor.dart";

class AdminContent extends StatelessWidget {
  const AdminContent({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    print("|||| build AdminContent ||||");
    print("     with selected workspace: ${adminState.getSelectedWorkspace()}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Floor(
            blockedWorkspaceIds: const [],
            floor: adminState.getFloor(),
            selectedWorkspace: adminState.getSelectedWorkspace(),
            setSelectedWorkspace: (workspace) {
              adminState.selectWorkspace(workspace);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 1,
          child: adminState.getSelectedWorkspace() != null
              ? EditWorkspace(
                  selectedWorkspace: adminState.getSelectedWorkspace()!,
                )
              : SizedBox(),
        ),
      ],
    );
  }
}

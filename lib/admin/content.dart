import "package:flexwork/models/floors.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/workspaceSelectionNotifier.dart";
import "../widgets/floor.dart";

class AdminContent extends StatelessWidget {
  final Floors floor;
  const AdminContent({
    required this.floor,
    super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<WorkspaceSelectionNotifier>(context);
    return Column(
      children: [
        Floor(floor: floor, notifier: notifier),
      ],
    );
  }
}

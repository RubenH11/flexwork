import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/editWorkspace.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../widgets/newSpaceFloor.dart';
import '../../models/newSpaceNotifier.dart';

class NewSpaceContent extends StatelessWidget {
  final bool isValid;
  final FocusNode moveFocusNode;
  const NewSpaceContent({
    required this.moveFocusNode,
    required this.isValid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("build newSpace content");
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);
    return Column(
      children: [
        NewSpaceFloor(isValid: isValid),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: EditWorkspace(
            selectedWorkspace: newSpaceNotifier.workspace,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: Placeholder(
              fallbackHeight: 30,
            )),
            Expanded(
                child: Placeholder(
              fallbackHeight: 30,
            )),
          ],
        ),
      ],
    );
  }
}

import "package:flexwork/admin/admin.dart";
import "package:flexwork/models/adminState.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../widgets/customElevatedButton.dart";

class NewSpaceMenuAbove extends StatelessWidget {
  const NewSpaceMenuAbove({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final adminState = Provider.of<AdminState>(context);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: (){
                adminState.setOpenPage(AdminPages.newSpaceRect);
              },
              active: adminState.getOpenPage() == AdminPages.newSpaceAdvanced,
              selected: adminState.getOpenPage() == AdminPages.newSpaceRect,
              text: "Rectangular",
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              onPressed: (){
                adminState.setOpenPage(AdminPages.newSpaceAdvanced);
              },
              active: adminState.getOpenPage() == AdminPages.newSpaceRect,
              selected: adminState.getOpenPage() == AdminPages.newSpaceAdvanced,
              text: "Advanced",
            ),
          ),
        ],
      ),
    );
  }
}

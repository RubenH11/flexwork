import "package:flutter/material.dart";
import "../../widgets/customElevatedButton.dart";

class NewSpaceMenuAbove extends StatelessWidget {
  final bool advancedMenu;
  final Function setAdvancedMenu;
  final Function setDefaultMenu;
  const NewSpaceMenuAbove({
    required this.setAdvancedMenu,
    required this.setDefaultMenu,
    required this.advancedMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: setDefaultMenu,
              active: advancedMenu,
              selected: !advancedMenu,
              text: "Rectangular",
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              onPressed: setAdvancedMenu,
              active: !advancedMenu,
              selected: advancedMenu,
              text: "Advanced",
            ),
          ),
        ],
      ),
    );
  }
}

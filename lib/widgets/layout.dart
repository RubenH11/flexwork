import "package:flutter/material.dart";

class Layout extends StatelessWidget {
  Widget menu;
  Widget? aboveMenu;
  Widget content;
  Layout({
    required this.menu,
    required this.content,
    this.aboveMenu,
    super.key,
  });

  final MENU_WIDTH = 325.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            if(aboveMenu != null) SizedBox(width: MENU_WIDTH, child: aboveMenu!),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: MENU_WIDTH,
                child: menu,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: content,
          ),
        ),
      ],
    );
  }
}

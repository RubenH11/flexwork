import "package:flexwork/database/database.dart";
import "package:flutter/material.dart";

class Layout extends StatelessWidget {
  Widget menu;
  Widget? aboveMenu;
  Widget content;
  Widget navigation;
  Layout({
    required this.menu,
    required this.content,
    this.aboveMenu,
    required this.navigation,
    super.key,
  });

  final MENU_WIDTH = 315.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          child: Row(
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Expanded(flex: 20, child: Center(child: navigation)),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    DatabaseFunctions.logout();
                  },
                  icon: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  if (aboveMenu != null)
                    SizedBox(width: MENU_WIDTH, child: aboveMenu!),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      width: MENU_WIDTH,
                      child: menu,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

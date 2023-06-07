import 'package:flexwork/database/database.dart';
import 'package:flexwork/widgets/navButton.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final List<NavButton> nav;
  const TopBar({
    super.key,
    required this.nav,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> navItems = [];
    navItems.addAll(nav);
    print(navItems.length);
    for (var i = nav.length - 1; i > 0; i--) {
      print(i);
      navItems.insert(
        i,
        VerticalDivider(
          color: Theme.of(context).colorScheme.onBackground,
          endIndent: 12,
          indent: 12,
          thickness: 1,
        ),
      );
    }

    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 20,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: navItems,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                DatabaseFunctions.logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}

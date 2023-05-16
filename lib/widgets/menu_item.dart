import "package:flutter/material.dart";

class MenuItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final Widget child;
  const MenuItem(
      {required this.icon,
      required this.title,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            SizedBox(
              width: 4,
            ),
            Text(title),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: child,
        ),
      ],
    );
  }
}

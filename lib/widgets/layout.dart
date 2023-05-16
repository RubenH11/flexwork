import "package:flutter/material.dart";

class Layout extends StatelessWidget {
  Widget menu;
  Widget content;
  Layout({
    required this.menu,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          width: 300,
          child: menu,
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

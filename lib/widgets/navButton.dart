import "package:flutter/material.dart";

class NavButton extends StatelessWidget {
  final bool selected;
  final Function action;
  final String text;

  const NavButton(
      {required this.selected,
      required this.action,
      required this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextButton(
        onPressed: () => action(),
        child: Text(
          text,
          style: selected
              ? const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.underline
                )
              : const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
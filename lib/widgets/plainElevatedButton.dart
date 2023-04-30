import "package:flutter/material.dart";

class PlainElevatedButton extends StatelessWidget {
  bool focused;
  String text;
  Icon? icon;
  Function action;

  PlainElevatedButton({
    required this.action,
    required this.focused,
    required this.text,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(focused
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.background),
        foregroundColor: MaterialStatePropertyAll(focused
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onBackground),
        minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)));

    if (icon == null) {
      return ElevatedButton(
        style: buttonStyle,
        child: Text(text),
        onPressed: () => action(),
      );
    } else {
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: () => action(),
        icon: icon!,
        label: Text(text),
      );
    }
  }
}

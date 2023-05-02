import "package:flutter/material.dart";

class PlainElevatedButton extends StatelessWidget {
  bool focused;
  Widget child;
  Icon? icon;
  Function onPressed;

  PlainElevatedButton({
    required this.onPressed,
    required this.focused,
    required this.child,
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
        child: child,
        onPressed: () => onPressed(),
      );
    } else {
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: () => onPressed(),
        icon: icon!,
        label: child,
      );
    }
  }
}

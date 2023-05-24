import "package:flutter/material.dart";

class CustomElevatedButton extends StatelessWidget {
  bool active;
  bool selected;
  String? text;
  IconData? icon;
  Function onPressed;
  Color? selectedColor;
  bool? alignLeft;

  CustomElevatedButton({
    required this.onPressed,
    required this.active,
    required this.selected,
    this.selectedColor,
    this.text,
    this.icon,
    this.alignLeft,
    super.key,
  });

  var tapDown = false;
  Color getTextColor(BuildContext context) {
    if (!selected && active) {
      return Theme.of(context).colorScheme.onSecondary;
    }
    if (!selected && !active) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.onPrimary;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    if (selected && active) {
      return selectedColor != null
          ? selectedColor!
          : Theme.of(context).colorScheme.primary;
    } else if (selected && !active) {
      return selectedColor != null
          ? selectedColor!.withOpacity(0.5)
          : Theme.of(context).colorScheme.primary.withOpacity(0.5);
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(context);
    final backgroundColor = getBackgroundColor(context);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: active ? () => onPressed() : null,
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon!,
                  color: textColor,
                ),
              if (icon != null && text != null)
                SizedBox(
                  width: 5,
                ),
              if (text != null)
                Text(
                  text!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

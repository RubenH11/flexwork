import "package:flutter/material.dart";

class CustomElevatedButton extends StatefulWidget {
  bool active;
  String text;
  Function onPressed;
  bool? alignLeft;

  CustomElevatedButton({
    required this.onPressed,
    required this.active,
    required this.text,
    this.alignLeft,
    super.key,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomElevatedButton> {
  var tapDown = false;

  Color getTextColor(BuildContext context) {
    if (widget.active) {
      return Theme.of(context).colorScheme.onPrimary;
    } else {
      return Theme.of(context).colorScheme.onBackground;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    if (!widget.active) {
      return Theme.of(context).colorScheme.background;
    }

    if (tapDown) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.8);
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(context);
    final backgroundColor = getBackgroundColor(context);

    return Expanded(
      child: GestureDetector(
        onTap: widget.active ? () => widget.onPressed() : null,
        onTapDown: (details) {
          setState(() {
            tapDown = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            tapDown = false;
          });
        },
        child: Container(
          color: backgroundColor,
          width: double.infinity,
          height: 30,
          child: Center(
            child: Text(widget.text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: textColor)),
          ),
        ),
      ),
    );
  }
}

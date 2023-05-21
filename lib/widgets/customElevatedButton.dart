import "package:flutter/material.dart";

class CustomElevatedButton extends StatefulWidget {
  bool active;
  bool selected;
  String? text;
  Icon? icon;
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

  @override
  State<CustomElevatedButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomElevatedButton> {
  var tapDown = false;
  Color getTextColor(BuildContext context) {
    if (!widget.selected && widget.active) {
      return Theme.of(context).colorScheme.onSecondary;
    }
    if (!widget.selected && !widget.active) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.onPrimary;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    if (widget.selected && widget.active) {
      return widget.selectedColor != null ? widget.selectedColor! : Theme.of(context).colorScheme.primary;
    } else if (widget.selected && !widget.active) {
      return widget.selectedColor != null ? widget.selectedColor!.withOpacity(0.5) : Theme.of(context).colorScheme.primary.withOpacity(0.5);
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(context);
    final backgroundColor = getBackgroundColor(context);

    return GestureDetector(
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.icon != null) widget.icon!,
            if(widget.icon != null && widget.text != null) SizedBox(width: 5,),
            if (widget.text != null)
              Text(
                widget.text!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: textColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

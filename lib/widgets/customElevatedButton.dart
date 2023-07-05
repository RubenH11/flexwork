import "package:flutter/material.dart";

class CustomElevatedButton extends StatefulWidget {
  bool active;
  bool selected;
  String? text;
  IconData? icon;
  Function onPressed;
  Color? selectedColor;
  bool? alignLeft;
  bool? async;

  CustomElevatedButton({
    required this.onPressed,
    required this.active,
    required this.selected,
    this.selectedColor,
    this.text,
    this.icon,
    this.alignLeft,
    this.async,
    super.key,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  var loading = false;

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
      return widget.selectedColor != null
          ? widget.selectedColor!
          : Theme.of(context).colorScheme.primary;
    } else if (widget.selected && !widget.active) {
      return widget.selectedColor != null
          ? widget.selectedColor!.withOpacity(0.5)
          : Theme.of(context).colorScheme.primary.withOpacity(0.5);
    } else {
      return Theme.of(context).colorScheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(context);
    final backgroundColor = getBackgroundColor(context);

    return loading ? CircularProgressIndicator() : Material(
      color: backgroundColor,
      child: InkWell(
        onTap: widget.active
            ? () {
                if (widget.async = true) {
                  setState(() {
                    loading = true;
                  });
                  widget.onPressed();
                  setState(() {
                    loading = false;
                  });
                } else {
                  widget.onPressed();
                }
              }
            : null,
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon!,
                  color: textColor,
                ),
              if (widget.icon != null && widget.text != null)
                SizedBox(
                  width: 5,
                ),
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
      ),
    );
  }
}

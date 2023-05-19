import "package:flutter/material.dart";

class CustomTextButton extends StatefulWidget {
  bool selected;
  String text;
  Function onPressed;
  bool? alignLeft;

  CustomTextButton({
    required this.onPressed,
    required this.selected,
    required this.text,
    this.alignLeft,
    super.key,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    textColor =  widget.selected ? Color.fromARGB(255, 134, 159, 249) : Colors.black;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        onTapDown: (details) {
          print("tap down");
          setState(() {
            textColor = widget.selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Theme.of(context).colorScheme.onSecondary.withOpacity(0.5);
          });
        },
        onTapUp: (details) {
          print("tap up");
          setState(() {
            textColor = widget.selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSecondary;
          });
        },
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Center(
            child: Text(widget.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor)),
          ),
        ),
      ),
    );
  }
}

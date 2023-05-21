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
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.onPressed();
            },
            onTapDown: (details) {
              setState(() {
                textColor = widget.selected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSecondary.withOpacity(0.5);
              });
            },
            onTapUp: (details) {
              setState(() {
                textColor = widget.selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondary;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Text(widget.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor), textAlign: widget.alignLeft == null ? TextAlign.center : widget.alignLeft! ? TextAlign.left : TextAlign.center,),
            ),
          ),
        ),
      ],
    );
  }
}

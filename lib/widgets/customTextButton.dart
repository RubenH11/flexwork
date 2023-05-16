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
  void initState() {
    textColor =
        widget.selected ? Color.fromARGB(255, 134, 159, 249) : Colors.black;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   style: ButtonStyle(minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)), alignment: alignLeft == true ? Alignment.centerLeft : Alignment.center),
    //   child: Text(
    //     text,
    //     textAlign: alignLeft != null && alignLeft == true ? TextAlign.left : TextAlign.center,
    //     style: selected
    //         ? TextStyle(
    //             color: Theme.of(context).colorScheme.primary,
    //             fontWeight: FontWeight.bold)
    //         : TextStyle(color: Theme.of(context).colorScheme.onSecondary),

    //   ),
    //   onPressed: () => onPressed(),
    // );

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onPressed(),
        onTapDown: (details) {
          setState(() {
            textColor = widget.selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                : Theme.of(context).colorScheme.onSecondary.withOpacity(0.8);
          });
        },
        onTapUp: (details) {
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

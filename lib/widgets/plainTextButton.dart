import "package:flutter/material.dart";

class PlainTextButton extends StatelessWidget {
  bool selected;
  String text;
  Function action;
  bool? alignLeft;

  PlainTextButton({
    required this.action,
    required this.selected,
    required this.text,
    this.alignLeft,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)), alignment: alignLeft == true ? Alignment.centerLeft : Alignment.center),
      child: Text(
        text,
        textAlign: alignLeft != null && alignLeft == true ? TextAlign.left : TextAlign.center,
        style: selected
            ? TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)
            : TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            
      ),
      onPressed: () => action(),
    );
  }
}

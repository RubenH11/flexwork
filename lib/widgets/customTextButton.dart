import "package:flutter/material.dart";

class CustomTextButton extends StatelessWidget {
  bool selected;
  double? width;
  String? text;
  IconData? icon;
  Function onPressed;
  TextAlign? textAlign;
  Color? color;
  double? size;
  TextStyle? style;

  CustomTextButton({
    required this.onPressed,
    required this.selected,
    this.width,
    this.text,
    this.icon,
    this.size,
    this.textAlign,
    this.color,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _style = style ?? const TextStyle();
    var textColor =
        selected ? Color.fromARGB(255, 134, 159, 249) : Colors.black;

    if (color != null) {
      textColor = color!;
    }
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onPressed(),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment:
                      textAlign == TextAlign.right || textAlign == TextAlign.end
                          ? MainAxisAlignment.end
                          : textAlign == TextAlign.left ||
                                  textAlign == TextAlign.start
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(
                        icon!,
                        color: textColor,
                      ),
                    if (icon != null && text != null) const SizedBox(width: 5),
                    if (text != null)
                      Text(
                        text!,
                        style: _style.merge(TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size == null ? Theme.of(context).textTheme.bodyMedium!.fontSize : size!,
                            color: textColor)),
                        textAlign: textAlign ?? TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

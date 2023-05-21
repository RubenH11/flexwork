import "package:flexwork/admin/newSpace/keyboardListener.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool onlyInts;
  final bool onlyDecimals;
  final Function? onFocus;
  final Function? onUnfocus;
  final bool takeSingleFocus;
  const CustomTextField({
    required this.controller,
    this.onFocus,
    this.onUnfocus,
    this.onlyInts = false,
    this.onlyDecimals = false,
    required this.takeSingleFocus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    assert(!(onlyDecimals && onlyInts));

    final focusNode = takeSingleFocus ? IgnoreOthersFocusnode() : FocusScopeNode();

    var formatter = null;
    if (onlyDecimals) {
      formatter = [FilteringTextInputFormatter.allow(RegExp(r'^[\d.]*$'))];
    } else if (onlyInts) {
      formatter = [FilteringTextInputFormatter.digitsOnly];
    }

    final borderColor = Theme.of(context).colorScheme.primary;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: () {
        print("textfield was focused");
        if (onFocus != null) {
          onFocus!();
        }
        focusNode.requestFocus();
      },
      onTapOutside: (_) {
        if (focusNode.hasFocus) {
          print("textfield was unfocused");
          if (onUnfocus != null) {
            onUnfocus!();
          }
        }
      },
      style: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(color: borderColor, fontWeight: FontWeight.bold),
          ),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.zero),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: borderColor))),
      // keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: formatter,
    );
  }
}

import 'package:flexwork/admin/newSpace/content.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool onlyPosInts;
  final bool onlyDecimals;
  final String? placeholder;
  final TextAlign? textAlign;
  final Function(String)? onChanged;
  final bool takeSingleFocus;
  final void Function()? onEditingComplete;
  final bool password;
  final bool isDense;
  final String? value;
  const CustomTextField({
    required this.controller,
    this.onlyPosInts = false,
    this.onlyDecimals = false,
    this.onEditingComplete,
    required this.takeSingleFocus,
    this.onChanged,
    super.key,
    this.placeholder,
    this.textAlign,
    this.password = false,
    this.isDense = false,
    this.value,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    assert(!(widget.onlyDecimals && widget.onlyPosInts));

    if(widget.value != null) {
      widget.controller.text = widget.value!;
    }

    final focusNode =
        widget.takeSingleFocus ? IgnoreOthersFocusnode() : FocusNode();

    var formatter = null;
    if (widget.onlyDecimals) {
      formatter = [FilteringTextInputFormatter.allow(RegExp(r'^[\d.]*$'))];
    } else if (widget.onlyPosInts) {
      formatter = [FilteringTextInputFormatter.digitsOnly];
    }

    final focusedBorderColor = Theme.of(context).colorScheme.primary;
    final borderColor = Theme.of(context).colorScheme.onBackground;

    return TextField(
      obscureText: widget.password,
      controller: widget.controller,
      focusNode: focusNode,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      onEditingComplete: () {
        focusNode.unfocus();
        if (widget.onEditingComplete != null) {
          widget.onEditingComplete!();
        }
      },
      // onTap: () {
      //   print("textfield was focused");
      //   // if (onFocus != null) {
      //   //   onFocus!();
      //   // }
      //   if (!focusNode.hasFocus) {
      //     focusNode.requestFocus();
      //   }
      // },
      // onTapOutside: (_) {
      //   if (focusNode.hasFocus) {
      //     print("textfield was unfocused");
      //     // if (onUnfocus != null) {
      //     //   onUnfocus!();
      //     // }
      //   }
      // },
      style: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(color: borderColor, fontWeight: FontWeight.bold),
          ),
      textAlign: widget.textAlign ?? TextAlign.left,
      decoration: InputDecoration(
        contentPadding: widget.isDense ? EdgeInsets.all(10) : null,
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.zero),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor),
        ),
      ),
      // keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: formatter,
    );
  }
}

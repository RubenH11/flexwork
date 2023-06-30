import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/newSpaceNotifier.dart";
import 'package:flutter/services.dart';

class NewSpaceTextField extends StatefulWidget {
  // final void Function(String, NewSpaceNotifier) onChanged;
  final String Function(NewSpaceNotifier) setOnRebuild;
  final bool Function(String) onSubmit;
  final bool Function(double) inputCheck;

  NewSpaceTextField({
    required this.setOnRebuild,
    required this.onSubmit,
    required this.inputCheck,
    super.key,
  });

  @override
  State<NewSpaceTextField> createState() => _NewSpaceTextFieldState();
}

class _NewSpaceTextFieldState extends State<NewSpaceTextField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  var error = false;
  var cursorPos = 0;
  var setStateWasCalled = false;

  void submit() {
    focusNode.unfocus();
    widget.onSubmit(controller.text);
  }

  @override
  build(BuildContext context) {
    final newSpaceNotifier =
        Provider.of<NewSpaceNotifier>(context, listen: false);
    if (!setStateWasCalled) {
      controller.text = widget.setOnRebuild(newSpaceNotifier);
    }
    setStateWasCalled = false;
    if (controller.text.length >= cursorPos) {
      controller.selection = TextSelection.collapsed(offset: cursorPos);
    }

    final borderColor = error
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(color: borderColor, fontWeight: FontWeight.bold),
          ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          isDense: true,
          border:
              OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: borderColor))),
      onTapOutside: (_) {
        if (focusNode.hasFocus) {
          submit();
        }
      },
      onChanged: (value) {
        setState(() {
          setStateWasCalled = true;
          cursorPos = controller.selection.baseOffset;
          if (value == "") {
            error = true;
            return;
          }

          final input = double.parse(value);
          if (!widget.inputCheck(input)) {
            error = true;
          } else {
            error = false;
          }
        });
      },
      onEditingComplete: submit,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[\d.]*$')), // Accept only numbers and dots
      ],
    );
  }
}

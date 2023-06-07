import "dart:async";

import "package:flutter/material.dart";

void showBottomSheetWithTimer(BuildContext context, String message, {Color? color, Color? textColor, bool error = false, bool succes = false} ) {
  final backgroundColor = error ? Theme.of(context).colorScheme.error : succes ? Colors.green : color ??= Colors.grey;
  final bottomSheetController = Scaffold.of(context).showBottomSheet(
    (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 30,
        color: backgroundColor,
        child: Center(
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor ??= Colors.white)),
        ),
      );
    },
    enableDrag: true,
  );

  Timer(const Duration(seconds: 2), () {
    bottomSheetController.close();
  });
}
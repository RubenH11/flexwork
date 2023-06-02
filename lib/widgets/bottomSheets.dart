import "dart:async";

import "package:flutter/material.dart";

void showBottomSheetWithTimer(BuildContext context, String message, Color color, Color? textColor) {
  final bottomSheetController = Scaffold.of(context).showBottomSheet(
    (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 30,
        color: color,
        child: Center(
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor)),
        ),
      );
    },
    enableDrag: true,
  );

  Timer(const Duration(seconds: 2), () {
    bottomSheetController.close();
  });
}
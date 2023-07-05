import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservationConflict.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../models/newReservationNotifier.dart';
import '../../widgets/customElevatedButton.dart';
import "dart:html" as html;

class MakeReserationButton extends StatelessWidget {
  final void Function() refreshPage;
  const MakeReserationButton({
    super.key,
    required this.refreshPage,
  });

  @override
  Widget build(BuildContext context) {
    print("|||| MakeReserationButton ||||");
    final newRes = Provider.of<NewReservationNotifier>(context);

    return FutureBuilder(
        future: newRes.isValid(),
        builder: (context, isValidSnapshot) {
          if (isValidSnapshot.hasError) {
            return Text(isValidSnapshot.error.toString());
          }

          if (!isValidSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final isValid = isValidSnapshot.data!;
          return CustomElevatedButton(
            onPressed: () async {
              for (var request in newRes.getRequests()) {
                await DatabaseFunctions.addRequest(request);
              }
              final success = await DatabaseFunctions.addReservations(newRes);
              if(success){
                showBottomSheetWithTimer(context, "Succesfully made reservations", succes: true);
                newRes.clear();
                html.window.location.reload();
              }
              else{
                showBottomSheetWithTimer(context, "Could not make reservations, please check 'My reservations' to see what happened", error: true);
              }
              
              newRes.clear();
            },
            active: isValid,
            selected: isValid,
            text: "make reservation",
          );
        });
  }
}

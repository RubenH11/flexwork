import 'package:flexwork/database/database.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservationConflict.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../models/newReservationNotifier.dart';
import '../../widgets/customElevatedButton.dart';

class MakeReserationButton extends StatelessWidget {
  const MakeReserationButton({
    super.key,
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
              print("clicked confirm");
              // for (var request in newRes.getRequests()) {
              //   await FirebaseService().requests.add(request);
              // }
              // await FirebaseService().reservations.add(newRes);

              // print("22222");
              for (var request in newRes.getRequests()) {
                await DatabaseFunctions.addRequest(request);
              }
              DatabaseFunctions.addReservations(newRes);
              newRes.clear();
              // print("3333");
            },
            active: isValid,
            selected: isValid,
            text: "make reservation",
          );
        });
  }
}

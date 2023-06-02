import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservationConflict.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../models/newReservationNotifier.dart';
import '../../widgets/customElevatedButton.dart';
import '../../database/firebaseService.dart';

class MakeReserationButton extends StatelessWidget {
  const MakeReserationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("|||| MakeReserationButton ||||");
    final newRes = Provider.of<NewReservationNotifier>(context);

    return CustomElevatedButton(
      onPressed: () async {
        print("clicked confirm");
        for (var request in newRes.getRequests()) {
          await FirebaseService().requests.add(request);
        }
        await FirebaseService().reservations.add(newRes);
        print("22222");
        newRes.clear();
        print("3333");
      },
      active: newRes.isValid(),
      selected: newRes.isValid(),
      text: "make reservation",
    );
  }
}

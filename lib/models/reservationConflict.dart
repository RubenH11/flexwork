import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flexwork/database/firebaseService.dart';

class ReservationConflict{
  final String _reservationId;
  final DateTime _start;
  final DateTime _end;

  ReservationConflict({
    required DateTime end,
    required String reservationId,
    required DateTime start,
  })  : _end = end,
        _start = start,
        _reservationId = reservationId;

  DateTime getStart(){
    return _start;
  }

  DateTime getEnd(){
    return _end;
  }

  String getReservationId(){
    return _reservationId;
  }

  String getWorkspaceId(){
    final res = FirebaseService().reservations.getById(_reservationId);
    return res.getWorkspaceId();
  }
}

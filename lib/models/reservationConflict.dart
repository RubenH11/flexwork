
class ReservationConflict{
  final int _reservationId;
  final DateTime _start;
  final DateTime _end;
  final int _workspaceId;

  ReservationConflict({
    required DateTime end,
    required int reservationId,
    required DateTime start,
    required int workspaceId,
  })  : _end = end,
        _start = start,
        _workspaceId = workspaceId,
        _reservationId = reservationId;

  DateTime getStart(){
    return _start;
  }

  DateTime getEnd(){
    return _end;
  }

  int getReservationId(){
    return _reservationId;
  }

  int getWorkspaceId(){
    return _workspaceId;
  }
}

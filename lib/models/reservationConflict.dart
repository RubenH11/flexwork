class ReservationConflict {
  final int
      _reservationId; // if reservationID is -1, it means that it is a blocked moment
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

  bool isEqual(ReservationConflict other) {
    return _start == other.getStart() &&
        _end == other.getEnd() &&
        _workspaceId == other.getWorkspaceId() &&
        _reservationId == other.getReservationId();
  }

  DateTime getStart() {
    return _start;
  }

  DateTime getEnd() {
    return _end;
  }

  int getReservationId() {
    return _reservationId;
  }

  int getWorkspaceId() {
    return _workspaceId;
  }
}

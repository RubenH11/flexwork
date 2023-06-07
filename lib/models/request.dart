class Request {
  final int _id;
  final int _userId;
  final int _reservationId;
  final DateTime _start;
  final DateTime _end;
  final String _message;

  Request({
    required int id,
    required String message,
    required int userId,
    required int reservationId,
    required DateTime start,
    required DateTime end,
  })  : _id = id,
        _message = message,
        _userId = userId,
        _start = start,
        _end = end,
        _reservationId = reservationId;

  // String getWorkspaceId() {
  //   return _workspaceId;
  // }

  int getId(){
    return _id;
  }

  int getUserId() {
    return _userId;
  }

  int getReservationId(){
    return _reservationId;
  }

  String getMessage() {
    return _message;
  }

  DateTime getStart(){
    return _start;
  }

  DateTime getEnd(){
    return _end;
  }
}

class Request {
  final String _id;
  final String _userId;
  final String _reservationId;
  final DateTime _start;
  final DateTime _end;
  final String _message;

  Request({
    required String id,
    required String message,
    required String reservationId,
    required String userId,
    // required String workspaceId,
    required DateTime start,
    required DateTime end,
  })  : _id = id,
        _message = message,
        _reservationId = reservationId,
        _userId = userId,
        _start = start,
        _end = end;

  // String getWorkspaceId() {
  //   return _workspaceId;
  // }

  String getId(){
    return _id;
  }

  String getUserId() {
    return _userId;
  }

  String getReservationId() {
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

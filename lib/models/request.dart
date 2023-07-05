class Request {
  final int _id;
  final int _userId;
  final DateTime _start;
  final DateTime _end;
  final String _message;
  final int _workspaceId;

  Request({
    required int id,
    required String message,
    required int userId,
    required DateTime start,
    required DateTime end,
    required int workspaceId,
  })  : _id = id,
        _message = message,
        _userId = userId,
        _start = start,
        _workspaceId = workspaceId,
        _end = end;

  int getWorkspaceId() {
    return _workspaceId;
  }

  int getId(){
    return _id;
  }

  int getUserId() {
    return _userId;
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

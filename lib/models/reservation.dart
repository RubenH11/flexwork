import 'package:flexwork/models/workspace.dart';
import 'package:intl/intl.dart';

class Reservation{
  final String _id;
  final String _uid;
  final DateTime _start;
  final DateTime _end;
  final String _workspaceId;

  Reservation(this._id, this._uid, this._start, this._end, this._workspaceId);

  @override
  operator ==(Object other){
    assert(other is Reservation);
    final otherRes = other as Reservation;
    return otherRes.getStart() == _start && otherRes.getEnd() == _end && otherRes.getUserId() == _uid && otherRes.getWorkspaceId() == getWorkspaceId();
  }

  @override
  String toString() {
    return "Reservation [$_id]: from $_start until $_end";
  }

  DateTime getStart(){
    return _start;
  }

  DateTime getEnd(){
    return _end;
  }

  String getUserId(){
    return _uid;
  }

  String getWorkspaceId(){
    return _workspaceId;
  }

  String getId(){
    return _id;
  }
  
}
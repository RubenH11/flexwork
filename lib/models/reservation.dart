import 'package:flexwork/models/workspace.dart';
import 'package:intl/intl.dart';

class Reservation{
  final int _id;
  final int _uid;
  final DateTime _start;
  final DateTime _end;
  final int _workspaceId;

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

  int getUserId(){
    return _uid;
  }

  int getWorkspaceId(){
    return _workspaceId;
  }

  int getId(){
    return _id;
  }
  
}
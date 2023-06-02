import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservation.dart';

class RequestsRepo {
  final List<Request> _requests;

  RequestsRepo(this._requests);

  final collection = FirebaseService().firestore.collection("requests");

  Future<void> add(Request request) async {
    print("add request");
    await collection.add({
      "userId": request.getUserId(),
      "message": request.getMessage(),
      "reservationId": request.getReservationId(),
      "start": request.getStart().toIso8601String(),
      "end": request.getEnd().toIso8601String(),
    });
  }

  Future<void> accept(Request request, String workspaceId) async {
    await FirebaseService().reservations.addReservation(Reservation('NO_ID', request.getUserId(), request.getStart(), request.getEnd(), workspaceId));
    await delete(request.getId());
  }

  Future<void> delete(String requestId) async {
    await collection.doc(requestId).delete();
  }

  List<Request> getIncomingRequests() {
    final reservationIds = FirebaseService()
        .reservations
        .get(uid: FirebaseAuth.instance.currentUser!.uid)
        .map((res) => res.getId());

    return [..._requests]
        .where((request) => reservationIds.contains(request.getReservationId()))
        .toList();
  }

  List<Request> getOutgoingRequests(){
    return _requests.where((req) => req.getUserId() == FirebaseAuth.instance.currentUser!.uid).toList();
  }
}

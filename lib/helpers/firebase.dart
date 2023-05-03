import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/foundation.dart";

class FirebaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> addReservation(DateTime startDateTime, DateTime endDateTime, String roomNumber) async {
    var docRef = await firestore.collection("reservations").add({
      "start": startDateTime,
      "end": endDateTime,
      "room_number": roomNumber
    });
    return docRef.id;
  }
}
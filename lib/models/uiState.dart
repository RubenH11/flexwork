import 'package:flutter/material.dart';

enum FlexworkPages{
  newReservation,
  myReservations,
}

class FlexWorkUIState extends ChangeNotifier{
  FlexworkPages _openPage = FlexworkPages.newReservation;

  FlexworkPages getOpenPage(){
    return _openPage;
  }

  void setOpenPage(FlexworkPages page){
    _openPage = page;
    notifyListeners();
  }
}
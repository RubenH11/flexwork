import "package:flexwork/models/request.dart";
import "package:flexwork/models/workspace.dart";
import 'package:flexwork/user/my_reservations/content.dart';
import 'package:flexwork/user/my_reservations/menu.dart';
import "package:flexwork/user/my_reservations/request.dart";
import "package:flutter/material.dart";

class MyReservations extends StatefulWidget {
  const MyReservations({super.key});

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

enum _ContentPages {
  reservations,
  request,
}

class _MyReservationsState extends State<MyReservations> {
  var content = _ContentPages.reservations;
  Workspace? _workspace;
  Request? _request;

  void seeMoreOfRequest(Workspace workspace, Request request) {
    _workspace = workspace;
    _request = request;
    setState(() {
      content = _ContentPages.request;
    });
  }

  void closeRequestView() {
    _workspace = null;
    _request = null;
    setState(() {
      content = _ContentPages.reservations;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("|||| _MyReservationsScreen ||||");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          width: 350,
          child: MyReservationsMenu(
            seeMoreOfRequest: seeMoreOfRequest,
            closeRequestView: closeRequestView,
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: content == _ContentPages.reservations
                ? const MyReservationsOverview()
                : MyReservationsRequest(
                    workspace: _workspace!, request: _request!),
          ),
        ),
      ],
    );
  }
}

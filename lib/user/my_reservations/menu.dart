import 'package:flexwork/helpers/database.dart';
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/user/my_reservations/myRequestList.dart";
import "package:flexwork/user/my_reservations/othersRequestList.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/futureBuilder.dart";
import "package:flexwork/widgets/menuItem.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MyReservationsMenu extends StatefulWidget {
  final void Function(Workspace, Request) seeMoreOfRequest;
  final void Function() closeRequestView;
  final void Function() update;
  const MyReservationsMenu({
    required this.seeMoreOfRequest,
    required this.closeRequestView,
    required this.update,
    super.key,
  });

  @override
  State<MyReservationsMenu> createState() => _MyReservationsMenuState();
}

class _MyReservationsMenuState extends State<MyReservationsMenu> {
  Request? selectedRequest;

  void _seeMoreOfRequest(Workspace workspace, Request request) {
    widget.seeMoreOfRequest(workspace, request);
    setState(() {
      selectedRequest = request;
    });
  }

  void _closeRequestView() {
    widget.closeRequestView();
    setState(() {
      selectedRequest = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (selectedRequest != null)
            CustomElevatedButton(
              onPressed: () {
                setState(() {
                  _closeRequestView();
                });
              },
              active: true,
              selected: false,
              icon: Icons.arrow_back_sharp,
              text: "go back to my reservations",
            ),
          if (selectedRequest != null) Divider(),
          MenuItem(
            icon: const Icon(Icons.warning_amber),
            title: "Requests",
            child: FlexworkFutureBuilder(
              future: DatabaseFunctions.getRequests(others: true),
              builder: (requests) {
                print("building Reqyests with $requests");
                return requests.isEmpty
                    ? Text(
                        "You have no incoming requests",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      )
                    : OthersRequestsList(
                        update: widget.update,
                        seeMoreOfRequest: _seeMoreOfRequest,
                        selectedRequest: selectedRequest,
                        requests: requests,
                      );
              },
            ),
          ),
          const Divider(),
          MenuItem(
            icon: const Icon(Icons.question_mark),
            title: "My requests",
            child: FlexworkFutureBuilder(
              future: DatabaseFunctions.getRequests(mine: true),
              builder: (requests) {
                print("building my Requests with $requests");
                return requests.isEmpty
                    ? Text("You have made no requests",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground))
                    : MyRequestsList(
                        update: widget.update,
                        seeMoreOfRequest: _seeMoreOfRequest,
                        selectedRequest: selectedRequest,
                        requests: requests,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

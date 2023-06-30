import 'package:flexwork/helpers/database.dart';
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/futureBuilder.dart";
import "package:flexwork/widgets/menuItem.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MyReservationsMenu extends StatefulWidget {
  final void Function(Workspace, Request) seeMoreOfRequest;
  final void Function() closeRequestView;
  const MyReservationsMenu({
    required this.seeMoreOfRequest,
    required this.closeRequestView,
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
                return RequestsList(
                  update: () {
                    setState(() {});
                  },
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
                return MyRequestsList(
                  update: () => setState(() {}),
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

class MyRequestsList extends StatelessWidget {
  final List<Request> requests;
  final void Function(Workspace, Request) seeMoreOfRequest;
  final Request? selectedRequest;
  final void Function() update;
  const MyRequestsList({
    required this.requests,
    required this.seeMoreOfRequest,
    required this.update,
    required this.selectedRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("building my request list with $requests");
    return ListView.builder(
        shrinkWrap: true,
        itemCount: requests.length,
        itemBuilder: (context, index) {
          late final String topText;
          late final String bottomText;
          final requestStart = requests[index].getStart();
          final requestEnd = requests[index].getEnd();
          if (DateTimeHelper.extractOnlyDay(requestStart) ==
              DateTimeHelper.extractOnlyDay(requestEnd)) {
            topText = DateFormat("dd MMM yyyy").format(
              requestStart,
            );
            bottomText = "${DateFormat("HH:mm").format(
              requestStart,
            )} - ${DateFormat("HH:mm").format(
              requestEnd,
            )}";
          } else {
            topText = "from: ${DateFormat("dd MMM yyyy - HH:mm").format(
              requestStart,
            )}";
            bottomText = "until: ${DateFormat("dd MMM yyyy - HH:mm").format(
              requestEnd,
            )}";
          }

          print(
              "will request workspace from res_id: ${requests[index].getReservationId()}");
          return FlexworkFutureBuilder(
            future: DatabaseFunctions.getWorkspace(
                reservationId: requests[index].getReservationId()),
            builder: (workspaces) {
              // print("66");
              if (workspaces.isEmpty) {
                print(
                    "ERROR, could not find workspace by reservation Id from request");
                return Icon(Icons.dns_sharp);
              }
              final workspace = workspaces[0];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "${workspace.getType()}  ${workspace.getIdentifier()}",
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("$topText    "),
                      Text(bottomText),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    requests[index].getMessage().replaceAll('\n', ' '),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            final result =
                                await DatabaseFunctions.deleteRequest(
                                    requests[index].getId());
                            if (result.item1 == true) {
                              showBottomSheetWithTimer(
                                  context, "Succesfully deleted request",
                                  succes: true);
                              update();
                            } else {
                              showBottomSheetWithTimer(
                                  context, "Could not delete request",
                                  error: true);
                            }
                          },
                          active: true,
                          selected: true,
                          text: "Delete",
                          selectedColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            seeMoreOfRequest(workspace, requests[index]);
                          },
                          active: selectedRequest != requests[index],
                          selected: selectedRequest == requests[index],
                          text: "See more",
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }
}

class RequestsList extends StatelessWidget {
  final void Function(Workspace, Request) seeMoreOfRequest;
  final Request? selectedRequest;
  final List<Request> requests;
  final void Function() update;
  const RequestsList({
    required this.seeMoreOfRequest,
    required this.requests,
    required this.selectedRequest,
    required this.update,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("building request list with $requests");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        late final String topText;
        late final String bottomText;
        final requestStart = requests[index].getStart();
        final requestEnd = requests[index].getEnd();
        if (DateTimeHelper.extractOnlyDay(requestStart) ==
            DateTimeHelper.extractOnlyDay(requestEnd)) {
          topText = DateFormat("dd MMM yyyy").format(
            requestStart,
          );
          bottomText = "${DateFormat("HH:mm").format(
            requestStart,
          )} - ${DateFormat("HH:mm").format(
            requestEnd,
          )}";
        } else {
          topText = "from: ${DateFormat("dd MMM yyyy - HH:mm").format(
            requestStart,
          )}";
          bottomText = "until: ${DateFormat("dd MMM yyyy - HH:mm").format(
            requestEnd,
          )}";
        }

        print(
            "will request workspace from res_id: ${requests[index].getReservationId()}");
        return FlexworkFutureBuilder(
          future: DatabaseFunctions.getWorkspace(
              reservationId: requests[index].getReservationId()),
          builder: (workspaces) {
            print("55");
            if (workspaces.isEmpty) {
              print(
                  "ERROR, could not find workspace by reservation Id from request");
              return SizedBox();
            }
            final workspace = workspaces[0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "${workspace.getType()}  ${workspace.getIdentifier()}",
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("$topText    "),
                    Text(bottomText),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  requests[index].getMessage().replaceAll('\n', ' '),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                        child: CustomElevatedButton(
                      onPressed: () async {
                        final result = await DatabaseFunctions.deleteRequest(
                          requests[index].getId(),
                        );
                        if (result.item1) {
                          showBottomSheetWithTimer(
                              context, "Succesfully rejected a request",
                              succes: true);
                          update();
                        } else {
                          showBottomSheetWithTimer(
                              context, "Could not reject requets",
                              error: true);
                        }
                      },
                      active: true,
                      selected: true,
                      selectedColor: Theme.of(context).colorScheme.error,
                      text: "Reject",
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          seeMoreOfRequest(workspace, requests[index]);
                        },
                        active: selectedRequest != requests[index],
                        selected: selectedRequest == requests[index],
                        text: "See more",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: CustomElevatedButton(
                      onPressed: () async {
                        final result = await DatabaseFunctions.acceptRequest(
                            requests[index].getId());
                        if (result.item1) {
                          showBottomSheetWithTimer(
                              context, "Succesfully granted a request",
                              succes: true);
                          update();
                        } else {
                          showBottomSheetWithTimer(
                              context, "Could not grant requets",
                              error: true);
                        }
                      },
                      active: true,
                      selected: true,
                      text: "Grant",
                    )),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

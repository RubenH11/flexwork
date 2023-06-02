import "package:flexwork/database/firebaseService.dart";
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
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
            child: RequestsList(
              seeMoreOfRequest: _seeMoreOfRequest,
              selectedRequest: selectedRequest,
              requests: FirebaseService().requests.getIncomingRequests(),
            ),
          ),
          const Divider(),
          MenuItem(
            icon: const Icon(Icons.question_mark),
            title: "My requests",
            child: MyRequestsList(
              seeMoreOfRequest: _seeMoreOfRequest,
              selectedRequest: selectedRequest,
              requests: FirebaseService().requests.getOutgoingRequests(),
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
  const MyRequestsList({
    required this.requests,
    required this.seeMoreOfRequest,
    required this.selectedRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          final reservation = FirebaseService()
              .reservations
              .getById(requests[index].getReservationId());
          final workspace = FirebaseService()
              .workspaces
              .get(id: reservation.getWorkspaceId())
              .first;
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
              CustomElevatedButton(
                onPressed: () {
                  seeMoreOfRequest(workspace, requests[index]);
                },
                active: selectedRequest != requests[index],
                selected: selectedRequest == requests[index],
                text: "See more",
              ),
            ],
          );
        });
  }
}

class RequestsList extends StatelessWidget {
  final void Function(Workspace, Request) seeMoreOfRequest;
  final Request? selectedRequest;
  final List<Request> requests;
  const RequestsList({
    required this.seeMoreOfRequest,
    required this.requests,
    required this.selectedRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

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

        final reservation = FirebaseService()
            .reservations
            .getById(requests[index].getReservationId());
        final workspace = FirebaseService()
            .workspaces
            .get(id: reservation.getWorkspaceId())
            .first;

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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
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
                    try {
                      await FirebaseService()
                          .requests
                          .accept(requests[index], workspace.getId());
                    } catch (error) {
                      showBottomSheetWithTimer(
                        context,
                        "Something went wrong",
                        Theme.of(context).colorScheme.error,
                        Theme.of(context).colorScheme.onError,
                      );
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
  }
}

import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/bottomSheets.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

          // print(
          //     "will request workspace from res_id: ${requests[index].getReservationId()}");
          return FlexworkFutureBuilder(
            future: DatabaseFunctions.getWorkspace(
                workspaceId: requests[index].getWorkspaceId()),
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
                              update();
                              showBottomSheetWithTimer(
                                context,
                                "Succesfully deleted request",
                                succes: true,
                              );
                              update();
                            } else {
                              showBottomSheetWithTimer(
                                context,
                                "Could not delete request",
                                error: true,
                              );
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

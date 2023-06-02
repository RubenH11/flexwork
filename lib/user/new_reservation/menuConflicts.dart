import "package:firebase_auth/firebase_auth.dart";
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/reservationConflict.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/menuItem.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

void openRequestDialog(
    {required BuildContext context, required Function(String) confirm}) {
  showDialog(
    context: context,
    builder: ((context) {
      final messageController = TextEditingController();
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        actionsPadding: EdgeInsets.all(20.0),
        // titleTextStyle: Theme.of(context).textTheme.bodyLarge,
        // title: Text("Request", textAlign: TextAlign.center,),
        content: SizedBox(
          height: 300,
          width: 400,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Explain why you need the workspace",
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  active: true,
                  onPressed: () {
                    // newResNotif.acceptReservationConflict(resConflict);
                    Navigator.pop(context);
                  },
                  selected: false,
                  text: "Cancel",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomElevatedButton(
                  active: true,
                  onPressed: () {
                    confirm(messageController.text);
                    Navigator.pop(context);
                  },
                  selected: true,
                  text: "Confirm",
                ),
              ),
            ],
          )
        ],
      );
    }),
  );
}

class Conflicts extends StatelessWidget {
  const Conflicts({super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| Conflicts ||||");
    final newResNotif = Provider.of<NewReservationNotifier>(context);

    final conflicts = newResNotif.getConflicts();

    return conflicts.isEmpty
        ? const SizedBox()
        : MenuItem(
            icon: Icon(Icons.warning_amber_sharp),
            title: "Conflicts",
            trailing: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    openRequestDialog(
                      context: context,
                      confirm: (message) {
                        for (var conflict in conflicts) {
                          final request = Request(
                            id: "",
                            start: conflict.getStart(),
                            end: conflict.getEnd(),
                            message: message,
                            reservationId: conflict.getReservationId(),
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            // workspaceId: newResNotif.getWorkspace()!.getId(),
                          );

                          newResNotif.rejectReservationConflict(
                            conflict,
                            request,
                          );
                        }
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.checklist),
                  onPressed: () {
                    for (var conflict in conflicts) {
                      newResNotif.acceptReservationConflict(conflict);
                    }
                  },
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: conflicts.length,
              itemBuilder: (context, index) {
                final conflictStart = conflicts[index].getStart();
                final conflictEnd = conflicts[index].getEnd();

                late final String topText;
                late final String bottomText;

                if (DateTimeHelper.extractOnlyDay(conflictStart) ==
                    DateTimeHelper.extractOnlyDay(conflictEnd)) {
                  topText = DateFormat("dd MMM yyyy").format(
                    conflictStart,
                  );
                  bottomText = "${DateFormat("HH:mm").format(
                    conflictStart,
                  )} - ${DateFormat("HH:mm").format(
                    conflictEnd,
                  )}";
                } else {
                  topText = "from: ${DateFormat("dd MMM yyyy - HH:mm").format(
                    conflictStart,
                  )}";
                  bottomText =
                      "until: ${DateFormat("dd MMM yyyy - HH:mm").format(
                    conflictEnd,
                  )}";
                }

                return ConflictItem(
                  conflict: conflicts[index],
                  topText: topText,
                  bottomText: bottomText,
                );
              },
            ),
          );
  }
}

class ConflictItem extends StatelessWidget {
  final String topText;
  final String bottomText;
  final ReservationConflict conflict;
  const ConflictItem({
    required this.topText,
    required this.bottomText,
    required this.conflict,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("|||| ConflictItem ||||");
    final newResNotif =
        Provider.of<NewReservationNotifier>(context, listen: false);

    late final Color checkColor;
    late final Color requestColor;
    late final Color textColor;
    switch (newResNotif.conflictIsAccepted(conflict)) {
      case true:
        requestColor = Colors.black;
        checkColor = Colors.green;
        textColor = checkColor;
        break;
      case false:
        requestColor = Theme.of(context).colorScheme.primary;
        checkColor = Colors.black;
        textColor = requestColor;
        break;
      default:
        textColor = Colors.black;
        requestColor = textColor;
        checkColor = textColor;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SizedBox(
            height: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topText,
                  style: TextStyle(color: textColor),
                ),
                Text(
                  bottomText,
                  style: TextStyle(color: textColor),
                )
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.question_answer,
            color: requestColor,
          ),
          splashRadius: 20,
          onPressed: () => openRequestDialog(
            context: context,
            confirm: (message) {
              final request = Request(
                id: "",
                start: conflict.getStart(),
                end: conflict.getEnd(),
                message: message,
                reservationId: conflict.getReservationId(),
                userId: FirebaseAuth.instance.currentUser!.uid,
                // workspaceId: newResNotif.getWorkspace()!.getId(),
              );

              newResNotif.rejectReservationConflict(
                conflict,
                request,
              );
            },
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.check,
            color: checkColor,
          ),
          splashRadius: 20,
          onPressed: () {
            newResNotif.acceptReservationConflict(conflict);
          },
        ),
      ],
    );
  }
}

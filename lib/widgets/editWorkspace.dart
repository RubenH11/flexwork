import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextField.dart";
import "package:flutter/material.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:tuple/tuple.dart";

class EditWorkspace extends StatelessWidget {
  final Workspace selectedWorkspace;
  EditWorkspace({
    required this.selectedWorkspace,
    super.key,
  });

  final typeController = TextEditingController();
  final identifierController = TextEditingController();
  final nicknameController = TextEditingController();
  final monitorsController = TextEditingController();
  final whiteboardsController = TextEditingController();
  final screensController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build edit area");
    final workspace = selectedWorkspace;
    typeController.text = workspace.getType();
    identifierController.text = workspace.getIdentifier();
    nicknameController.text = workspace.getNickname();
    monitorsController.text = workspace.getNumMonitors().toString();
    whiteboardsController.text = workspace.getNumWhiteboards().toString();
    screensController.text = workspace.getNumScreens().toString();

    // print("timestamps is ${timestamps.length} long");
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: 105,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Identifier")),
                  Expanded(
                    child: CustomTextField(
                        takeSingleFocus: true,
                        controller: identifierController),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Nickname")),
                  Expanded(
                    child: CustomTextField(
                      takeSingleFocus: true,
                      controller: nicknameController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: 105,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Workspace type")),
                  Expanded(
                    child: TypeAheadField<String>(
                      noItemsFoundBuilder: (context) {
                        return const SizedBox();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: typeController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.zero),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      suggestionsCallback: (value) {
                        final list = ["Office", "Meeting room"];
                        if (value == "") {
                          return list;
                        }
                        List<String> suggestion = [];
                        for (var option in list) {
                          if (option.startsWith(value)) {
                            suggestion.add(option);
                          }
                        }
                        return suggestion;
                      },
                      itemBuilder: (ctx, suggestion) {
                        return Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 18.0),
                          child: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (value) {
                        // print("selected $value");
                        typeController.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Monitors")),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                        takeSingleFocus: true,
                        controller: monitorsController,
                        onlyInts: true),
                  ),
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Whiteboards")),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                        takeSingleFocus: true,
                        controller: whiteboardsController,
                        onlyInts: true),
                  ),
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Large screen")),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                        takeSingleFocus: true,
                        controller: screensController,
                        onlyInts: true),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: TimeSlotList()),
      ],
    );
  }
}

class TimeSlotList extends StatefulWidget {
  const TimeSlotList({super.key});

  @override
  State<TimeSlotList> createState() => _TimeSlotListState();
}

class _TimeSlotListState extends State<TimeSlotList> {
    final timestamps = [
    Tuple2(DateTime.now(), DateTime.now()),
    Tuple2(DateTime.now(), DateTime.now()),
    Tuple2(DateTime.now(), DateTime.now()),
    Tuple2(DateTime.now(), DateTime.now()),
    Tuple2(DateTime.now(), DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          active: true,
          selected: false,
          icon: const Icon(Icons.add),
          text: "Add a blocked timeslot",
          onPressed: () async {
            // print("dateimte");
            try {
              final startDate = await showDatePicker(
                confirmText: "NEXT",
                helpText: "Start date",
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );
              if (startDate == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final startTime = await showTimePicker(
                confirmText: "NEXT",
                helpText: "Start time",
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.input,
              );
              if (startTime == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final endDate = await showDatePicker(
                confirmText: "NEXT",
                helpText: "End date",
                context: context,
                initialDate: startDate!,
                firstDate: startDate!,
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );
              if (endDate == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final endTime = await showTimePicker(
                helpText: "End time",
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.input,
              );
              if (endTime == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final startDateTime = startDate.add(
                  Duration(hours: startTime.hour, minutes: startTime.minute));
              final endDateTime = endDate!
                  .add(Duration(hours: endTime.hour, minutes: endTime.minute));

              if (startDateTime.isAtSameMomentAs(endDateTime)) {
                throw ErrorDescription("Start and end time where identical");
              } else if (startDateTime.isAfter(endDateTime)) {
                throw ErrorDescription("Start time was after end time");
              }

              setState(() {
                timestamps.add(Tuple2(startDateTime, endDateTime));
              });
            } catch (error) {
              final errorExplanation = error.toString();
              // ignore: use_build_context_synchronously
              if (error.toString() != "INTERUPTION") {
                showDialog(
                  context: context,
                  builder: (_) {
                    final errorColor = Theme.of(context).colorScheme.error;
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: errorColor, width: 10),
                          color: Colors.white,
                        ),
                        // height: 100,
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Please enter a new time range",
                              style: TextStyle(color: errorColor, fontSize: 16),
                            ),
                            Text(
                              errorExplanation,
                              style: TextStyle(color: errorColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              // print("building something");
              return Column(
                children: [
                  Row(
                    children: [
                      const Text("From: "),
                      Expanded(
                        child: Text(timestamps[index].item1.toIso8601String()),
                      ),
                      const Text("To: "),
                      Expanded(
                        child: Text(timestamps[index].item2.toIso8601String()),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              timestamps.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.delete,
                              color: Theme.of(ctx).colorScheme.error),
                          padding: EdgeInsets.zero,
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
            itemCount: timestamps.length,
          ),
        ),
      ],
    );
  }
}

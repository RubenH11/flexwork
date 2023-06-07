import "package:flexwork/database/database.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/bottomSheets.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import "package:flexwork/widgets/customTextField.dart";
import "package:flutter/material.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:intl/intl.dart";
import "package:tuple/tuple.dart";

// class EditWorkspace extends StatelessWidget {
//   const EditWorkspace({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

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
    typeController.text = workspace.getType();

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
                      child: const Text("Code")),
                  Expanded(
                    child: CustomTextField(
                        onChanged: (value) => workspace.setIdentifier(value),
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
                      onChanged: (value) => workspace.setNickname(value),
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
                      getImmediateSuggestions: true,
                      textFieldConfiguration: TextFieldConfiguration(
                        onChanged: (value) {
                          workspace.setType(value);
                          print("changed");
                        },
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
                      suggestionsCallback: (value) async {
                        final colors =
                            await DatabaseFunctions.getWorkspaceTypes();
                        return colors.keys;
                      },
                      itemBuilder: (ctx, suggestion) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 18.0),
                                child: Text(suggestion),
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              child: CustomTextButton(
                                selected: true,
                                text: "select color",
                                textAlign: TextAlign.center,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      var currentColor = workspace.getColor();
                                      return AlertDialog(
                                        titleTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        title: Text(
                                          'Scroll and select a color',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: SingleChildScrollView(
                                          child: BlockPicker(
                                            pickerColor: currentColor,
                                            onColorChanged: (Color color) {
                                              currentColor = color;
                                            },
                                            availableColors: [
                                              for (double hue = 0;
                                                  hue < 360;
                                                  hue += 5)
                                                HSLColor.fromAHSL(
                                                        1.0, hue, 1, 0.8)
                                                    .toColor(),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: <Widget>[
                                          CustomTextButton(
                                            text: "Select",
                                            selected: true,
                                            onPressed: () {
                                              // Process the selected color
                                              DatabaseFunctions
                                                  .addWorkspaceType(
                                                      suggestion, currentColor);
                                              print(
                                                  'Selected color: $currentColor');
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomTextButton(
                              selected: true,
                              icon: Icons.delete,
                              width: 60,
                              textAlign: TextAlign.center,
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () async {
                                try {
                                  await DatabaseFunctions.deleteWorkspaceType(
                                      suggestion);
                                  showBottomSheetWithTimer(
                                      context,
                                      "deleted succesfully",
                                      succes: true);
                                } catch (error) {
                                  showBottomSheetWithTimer(
                                      context, "Could not delete: $error",
                                      error: true);
                                }
                              },
                            ),
                          ],
                        );
                      },
                      onSuggestionSelected: (value) {
                        typeController.text = value;
                        workspace.setType(value);
                        print("selected");
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
                        onChanged: (value) =>
                            workspace.setNumMonitors(int.parse(value)),
                        takeSingleFocus: true,
                        controller: monitorsController,
                        onlyPosInts: true),
                  ),
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Whiteboards")),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                        onChanged: (value) =>
                            workspace.setNumWhiteboards(int.parse(value)),
                        takeSingleFocus: true,
                        controller: whiteboardsController,
                        onlyPosInts: true),
                  ),
                  Container(
                      width: 90,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text("Large screen")),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                        onChanged: (value) =>
                            workspace.setNumScreens(int.parse(value)),
                        takeSingleFocus: true,
                        controller: screensController,
                        onlyPosInts: true),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: TimeSlotList(
            workspace: selectedWorkspace,
          ),
        ),
      ],
    );
  }
}

class TimeSlotList extends StatefulWidget {
  final Workspace workspace;
  const TimeSlotList({
    required this.workspace,
    super.key,
  });

  @override
  State<TimeSlotList> createState() => _TimeSlotListState();
}

class _TimeSlotListState extends State<TimeSlotList> {
  @override
  Widget build(BuildContext context) {
    final timestamps = widget.workspace.getBlockedMoments();

    return Column(
      children: [
        CustomElevatedButton(
          active: true,
          selected: false,
          icon: Icons.add,
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
                throw ErrorDescription("INTERRUPTION");
              }
              final startTime = await showTimePicker(
                confirmText: "NEXT",
                helpText: "Start time",
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.input,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (startTime == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final endDate = await showDatePicker(
                confirmText: "NEXT",
                helpText: "End date",
                context: context,
                initialDate: startDate,
                firstDate: startDate,
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );
              if (endDate == null) {
                throw ErrorDescription("INTERUPTION");
              }
              final endTime = await showTimePicker(
                helpText: "End time",
                context: context,
                initialTime: startTime,
                initialEntryMode: TimePickerEntryMode.input,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (endTime == null) {
                throw ErrorDescription("INTERUPTION");
              }
              print("1");
              final startDateTime = startDate.add(
                  Duration(hours: startTime.hour, minutes: startTime.minute));
              print("2");
              final endDateTime = endDate
                  .add(Duration(hours: endTime.hour, minutes: endTime.minute));
              print("3");
              if (startDateTime.isAtSameMomentAs(endDateTime)) {
                throw ErrorDescription("Start and end time where identical");
              } else if (startDateTime.isAfter(endDateTime)) {
                throw ErrorDescription("Start time was after end time");
              }
              print("4");
              setState(() {
                widget.workspace
                    .addBlockedMoment(Tuple2(startDateTime, endDateTime));
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
              return Column(
                children: [
                  Row(
                    children: [
                      const Text("From: "),
                      Expanded(
                        child: Text(DateFormat('EEEE, dd-MM-yyyy, HH:mm')
                            .format(timestamps[index].item1)),
                      ),
                      const Text("To: "),
                      Expanded(
                        child: Text(DateFormat('EEEE, dd-MM-yyyy, HH:mm')
                            .format(timestamps[index].item2)),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.workspace.deleteBlockedMoment(index);
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

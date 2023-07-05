import 'dart:math';

import 'package:date_format_field/date_format_field.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/menuItem.dart';
import 'package:flutter/material.dart';
import 'package:date_format_field/src/formater.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

class NewReservationMenuTimepickers extends StatefulWidget {
  const NewReservationMenuTimepickers({super.key});

  @override
  State<NewReservationMenuTimepickers> createState() =>
      _NewReservationMenuTimepickersState();
}

enum _FieldState {
  error,
  valid,
  none,
}

class _NewReservationMenuTimepickersState
    extends State<NewReservationMenuTimepickers> {
  var startDateTimeState = _FieldState.error;
  var endDateTimeState = _FieldState.error;
  var startErrorMessage = "Something went wrong";
  var endErrorMessage = "Something went wrong";
  DateTime? startDate;
  DateTime? startTime;
  DateTime? endDate;
  DateTime? endTime;
  final startTimeController = TextEditingController();
  final startDateController = TextEditingController();
  final endTimeController = TextEditingController();
  final endDateController = TextEditingController();
  final durationMinController = TextEditingController();
  final durationHourController = TextEditingController();
  final startTimeFocusNode = FocusNode();
  final startDateFocusNode = FocusNode();
  final endTimeFocusNode = FocusNode();
  final endDateFocusNode = FocusNode();
  final durationMinFocusNode = FocusNode();
  final durationHourFocusNode = FocusNode();

  void updateFromDurationHours(int? number, NewReservationNotifier notif) {
    if (number != null && notif.getStartTime() != null) {
      final newStartDateTime = notif.getStartTime()!.add(
            Duration(
              hours: number,
              minutes: durationMinController.text == ""
                  ? 0
                  : int.parse(durationMinController.text),
            ),
          );
      print("endTime and endDate are set because of duration hour change");
      endTime = newStartDateTime;
      endDate = newStartDateTime;
      Provider.of<NewReservationNotifier>(context, listen: false)
          .setEndTime(newStartDateTime);
    }
  }

  void updateFromDurationMinutes(int? number, NewReservationNotifier notif) {
    if (number != null && notif.getStartTime() != null) {
      final newEndDateTime = notif.getStartTime()!.add(
            Duration(
                hours: durationHourController.text == ""
                    ? 0
                    : int.parse(durationHourController.text),
                minutes: number),
          );
      print("endTime and endDate are set because of duration minute change");
      endTime = newEndDateTime;
      endDate = newEndDateTime;
      Provider.of<NewReservationNotifier>(context, listen: false)
          .setEndTime(newEndDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild with state: ${startDateTimeState.name}");

    void findStateStart() {
      if (startDate == null || startTime == null) {
        startDateTimeState = _FieldState.none;
        return;
      }

      final newDateTime =
          DateTimeHelper.mergeDateAndTime(startDate!, startTime!);

      if (newDateTime.isBefore(DateTime.now())) {
        startDateTimeState = _FieldState.error;
        startErrorMessage = "Timestamp is in the past";
        return;
      }

      if (newDateTime.isAfter(DateTime.now().add(const Duration(days: 2560)))) {
        startDateTimeState = _FieldState.error;
        startErrorMessage = "Timestamp is too far in the future";
        return;
      }

      final newResNotif =
          Provider.of<NewReservationNotifier>(context, listen: false);

      final currEndDateTime = newResNotif.getEndTime();
      if (currEndDateTime != null) {
        if (currEndDateTime.isBefore(newDateTime)) {
          newResNotif.setEndTime(null);
          endDateTimeState = _FieldState.error;
          endErrorMessage = "Timestamp is no longer valid";
          return;
        }
      }
      startDateTimeState = _FieldState.valid;
    }

    void findStateEnd() {
      if (endDate == null || endTime == null) {
        endDateTimeState = _FieldState.none;
        return;
      }

      final newDateTime = DateTimeHelper.mergeDateAndTime(endDate!, endTime!);

      if (newDateTime.isBefore(DateTime.now())) {
        endDateTimeState = _FieldState.error;
        endErrorMessage = "Timestamp is in the past";
        return;
      }

      if (newDateTime.isAfter(DateTime.now().add(const Duration(days: 2560)))) {
        endDateTimeState = _FieldState.error;
        endErrorMessage = "Timestamp is too far in the future";
        return;
      }

      final newResNotif =
          Provider.of<NewReservationNotifier>(context, listen: false);

      final currStartDateTime = newResNotif.getStartTime();
      if (currStartDateTime != null) {
        if (currStartDateTime.isAfter(newDateTime)) {
          endDateTimeState = _FieldState.error;
          endErrorMessage = "Timestamp is before start timestamp";
          return;
        }
      }
      endDateTimeState = _FieldState.valid;
    }

    findStateStart();
    findStateEnd();

    return MenuItem(
      icon: Icon(Icons.access_time),
      title: "Timeframe",
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          //start datetime
          Selector<NewReservationNotifier, DateTime?>(
            selector: (context, notif) => notif.getStartTime(),
            builder: (context, value, child) {
              findStateStart();
              return Row(
                children: [
                  Expanded(child: Text("Start:")),
                  Expanded(
                    flex: 2,
                    child: _CustomDateField(
                      updateFields: () => setState(() {}),
                      focusNode: startDateFocusNode,
                      state: startDateTimeState,
                      value: value,
                      controller: startDateController,
                      onComplete: (datetime) {
                        startDate = datetime;
                        findStateStart();
                        if (startDateTimeState == _FieldState.valid) {
                          final newStartDateTime =
                              DateTimeHelper.mergeDateAndTime(
                                  startDate!, startTime!);
                          Provider.of<NewReservationNotifier>(context,
                                  listen: false)
                              .setStartTime(newStartDateTime);
                        }
                      },
                      hintText:
                          "e.g. '${DateFormat('dd-MM-yyyy').format(DateTime.now())}'",
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: _CustomTimeField(
                      focusNode: startTimeFocusNode,
                      state: startDateTimeState,
                      value: value,
                      hintText: "'09:00'",
                      controller: startTimeController,
                      updateFields: () => setState(() {}),
                      onComplete: (datetime) {
                        startTime = datetime;

                        findStateStart();

                        if (startDateTimeState == _FieldState.valid) {
                          final newStartDateTime =
                              DateTimeHelper.mergeDateAndTime(
                                  startDate!, startTime!);
                          Provider.of<NewReservationNotifier>(context,
                                  listen: false)
                              .setStartTime(newStartDateTime);
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 5),
          //start datetime error message
          if (startDateTimeState == _FieldState.error)
            Row(
              children: [
                Spacer(),
                Expanded(
                  child: Text(
                    startErrorMessage,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  flex: 3,
                )
              ],
            ),
          const SizedBox(height: 5),
          //duration
          Consumer<NewReservationNotifier>(
            builder: (context, notif, _) {
              final start = notif.getStartTime();
              final end = notif.getEndTime();

              return Row(
                children: [
                  Expanded(
                    child: Text("Duration:"),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        //duration field
                        Expanded(
                          flex: 5,
                          child: _CustomDurataionField(
                            controller: durationHourController,
                            focusNode: durationHourFocusNode,
                            hintText: "e.g. '2'",
                            state: _FieldState.none,
                            value: start == null || end == null
                                ? null
                                : notif
                                    .getEndTime()!
                                    .difference(notif.getStartTime()!)
                                    .inHours,
                            onComplete: (number) {
                              updateFromDurationHours(number, notif);
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        //+ and -
                        Expanded(
                            child: _AddAndSubtractHours(
                          hourController: durationHourController,
                          minController: durationMinController,
                          onPress: (number) =>
                              updateFromDurationHours(number, notif),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        //duration field
                        Expanded(
                          flex: 5,
                          child: _CustomDurataionField(
                            controller: durationMinController,
                            focusNode: durationMinFocusNode,
                            hintText: "e.g. '30'",
                            state: _FieldState.none,
                            value: start == null || end == null
                                ? null
                                : (notif
                                        .getEndTime()!
                                        .difference(notif.getStartTime()!)
                                        .inMinutes -
                                    60 *
                                        notif
                                            .getEndTime()!
                                            .difference(notif.getStartTime()!)
                                            .inHours),
                            onComplete: (number) {
                              updateFromDurationMinutes(number, notif);
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        //+ and -
                        Expanded(
                          child: _AddAndSubtractMinutes(
                            hourController: durationHourController,
                            minController: durationMinController,
                            onPress: (number) =>
                                updateFromDurationMinutes(number, notif),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          //end datetime
          Selector<NewReservationNotifier, DateTime?>(
            selector: (context, notif) => notif.getEndTime(),
            builder: (context, value, child) {
              findStateEnd();
              print(
                  "checked state after end time changed. It is: ${endDateTimeState}, with endTime $endTime and endDate $endDate");
              return Row(
                children: [
                  Expanded(child: Text("End:")),
                  Expanded(
                    flex: 2,
                    child: _CustomDateField(
                      updateFields: () => setState(() {}),
                      focusNode: endDateFocusNode,
                      state: endDateTimeState,
                      controller: endDateController,
                      value: value,
                      onComplete: (datetime) {
                        endDate = datetime;

                        findStateEnd();

                        if (endDateTimeState == _FieldState.valid) {
                          final newEndDateTime =
                              DateTimeHelper.mergeDateAndTime(
                                  endDate!, endTime!);
                          Provider.of<NewReservationNotifier>(context,
                                  listen: false)
                              .setEndTime(newEndDateTime);
                        }
                      },
                      hintText:
                          "e.g. '${DateFormat('dd-MM-yyyy').format(DateTime.now())}'",
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: _CustomTimeField(
                      focusNode: endTimeFocusNode,
                      state: endDateTimeState,
                      controller: endTimeController,
                      hintText: "'17:00'",
                      value: value,
                      updateFields: () => setState(() {}),
                      onComplete: (datetime) {
                        endTime = datetime;

                        findStateEnd();

                        if (endDateTimeState == _FieldState.valid) {
                          final newEndDateTime =
                              DateTimeHelper.mergeDateAndTime(
                                  endDate!, endTime!);
                          Provider.of<NewReservationNotifier>(context,
                                  listen: false)
                              .setEndTime(newEndDateTime);
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 5),
          //end datetime error message
          if (endDateTimeState == _FieldState.error)
            Row(
              children: [
                Spacer(),
                Expanded(
                  child: Text(
                    endErrorMessage,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  flex: 3,
                )
              ],
            ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _AddAndSubtractMinutes extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController hourController;
  final void Function(int?) onPress;
  const _AddAndSubtractMinutes({
    super.key,
    required this.hourController,
    required this.minController,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final notif = Provider.of<NewReservationNotifier>(context, listen: false);
    return SizedBox(
      height: 30,
      child: Column(
        children: [
          //+
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                if (minController.text.isEmpty) {
                  minController.text = '1';
                } else {
                  final newValue = int.parse(minController.text) + 1;
                  minController.text = newValue.toString();
                }
                if (notif.getStartTime() != null) {
                  notif.setEndTime(
                    notif.getStartTime()!.add(
                          Duration(
                              hours: hourController.text == ""
                                  ? 0
                                  : int.parse(hourController.text),
                              minutes: int.parse(minController.text)),
                        ),
                  );
                }
                onPress(int.parse(minController.text));
              },
              active: true,
              selected: false,
              icon: Icons.add,
              iconSize: 10,
            ),
          ),
          const SizedBox(height: 1),
          //-
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                if (minController.text.isEmpty) {
                  minController.text = '0';
                } else {
                  final newValue = int.parse(minController.text) - 1;
                  if (newValue < 0) {
                    return;
                  }
                  minController.text = newValue.toString();
                  if (notif.getStartTime() != null) {
                    notif.setEndTime(
                      notif.getStartTime()!.add(
                            Duration(
                                hours: hourController.text == ""
                                    ? 0
                                    : int.parse(hourController.text),
                                minutes: int.parse(minController.text)),
                          ),
                    );
                  }
                  onPress(int.parse(minController.text));
                }
              },
              active: true,
              selected: false,
              icon: Icons.remove,
              iconSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAndSubtractHours extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController hourController;
  final void Function(int?) onPress;
  const _AddAndSubtractHours({
    super.key,
    required this.hourController,
    required this.minController,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final notif = Provider.of<NewReservationNotifier>(context, listen: false);
    return SizedBox(
      height: 30,
      child: Column(
        children: [
          //+
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                if (hourController.text.isEmpty) {
                  hourController.text = '1';
                } else {
                  final newValue = int.parse(hourController.text) + 1;
                  hourController.text = newValue.toString();
                }
                if (notif.getStartTime() != null) {
                  notif.setEndTime(
                    notif.getStartTime()!.add(
                          Duration(
                            hours: int.parse(hourController.text),
                            minutes: minController.text == ""
                                ? 0
                                : int.parse(minController.text),
                          ),
                        ),
                  );
                }
                onPress(int.parse(hourController.text));
              },
              active: true,
              selected: false,
              icon: Icons.add,
              iconSize: 10,
            ),
          ),
          const SizedBox(height: 1),
          //-
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                if (hourController.text.isEmpty) {
                  hourController.text = '0';
                } else {
                  final newValue = int.parse(hourController.text) - 1;
                  if (newValue < 0) {
                    return;
                  }
                  hourController.text = newValue.toString();
                }
                if (notif.getStartTime() != null) {
                  notif.setEndTime(
                    notif.getStartTime()!.add(
                          Duration(
                            hours: int.parse(hourController.text),
                            minutes: minController.text == ""
                                ? 0
                                : int.parse(minController.text),
                          ),
                        ),
                  );
                }
                onPress(int.parse(hourController.text));
              },
              active: true,
              selected: false,
              icon: Icons.remove,
              iconSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTimeField extends StatelessWidget {
  _FieldState state;
  void Function(DateTime?) onComplete;
  String hintText;
  DateTime? value;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() updateFields;
  _CustomTimeField({
    super.key,
    required this.state,
    required this.onComplete,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.updateFields,
    this.value,
  });

  int _parseInt(String input) {
    return int.parse(input);
  }

  void _typeTemplate(String input, String seperator, int maxLength) {
    if (input.isEmpty) {
    } else if (input.runes.last < 48 || input.runes.last > 57) {
      controller.text = input.substring(0, input.length - 1);
    } else {
      switch (input.length) {
        case 1:
          if (_parseInt(input) > 2) {
            controller.text = '0$input$seperator';
          }
          break;
        case 2:
          if (_parseInt(input) == 24) {
            controller.text = '00:';
          } else if (_parseInt(input) > 23) {
            controller.text = input[0];
          }
          break;
        case 3:
          if (input[2] != seperator) {
            controller.text = int.parse(input[2]) < 6
                ? '${input.substring(0, 2)}$seperator${input[2]}'
                : '${input.substring(0, 2)}${seperator}0${input[2]}';
          }
          break;
        case 4:
          if (int.parse(input[3]) > 5) {
            controller.text =
                '${input.substring(0, 2)}${seperator}0${input[3]}';
          }
          break;
        case 5:
          break;
        default:
          if (input.length == maxLength + 1) {
            controller.text = input.substring(0, maxLength);
          }
      }
    }
    // move to the end of textfield
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  String formatNumber(int number, int desiredLength) {
    String numberString = number.toString();
    if (numberString.length >= desiredLength) {
      return numberString;
    } else {
      String padding = '0' * (desiredLength - numberString.length);
      return '$padding$numberString';
    }
  }

  void format(String input, int maxLength) {
    _typeTemplate(input, ':', maxLength);
  }

  static DateTime _parseTime(String input) {
    int hour = int.parse(input.substring(0, 2));
    int minute = int.parse(input.substring(3, 5));
    return DateTime(0, 0, 0, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    if (value != null && !focusNode.hasFocus) {
      controller.text =
          '${formatNumber(value!.hour, 2)}:${formatNumber(value!.minute, 2)}';
    }

    Color color = Colors.black;
    FontWeight fontWeight = FontWeight.normal;
    switch (state) {
      case _FieldState.error:
        color = Theme.of(context).colorScheme.error;
        break;
      case _FieldState.valid:
        color = Theme.of(context).colorScheme.primary;
        fontWeight = FontWeight.bold;
        break;
      default:
    }

    controller.addListener(
      () {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );

    return TextField(
      focusNode: focusNode,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontWeight: fontWeight),
      controller: controller,
      keyboardType: TextInputType.datetime,
      onChanged: (value) {
        const maxLength = 5;
        format(value, maxLength);
        print("parsing ${controller.text}");
        if (value.length == maxLength) {
          print("completed time");
          onComplete(_parseTime(controller.text));
        }
        updateFields();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _CustomDateField extends StatelessWidget {
  _FieldState state;
  void Function(DateTime?) onComplete;
  String hintText;
  DateTime? value;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() updateFields;
  _CustomDateField({
    super.key,
    required this.state,
    required this.onComplete,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.updateFields,
    this.value,
  });

  int _parseInt(String input) {
    return int.parse(input);
  }

  void _typeTemplate(String input, String seperator, int maxLength) {
    if (input.isEmpty) {
    } else if (input.runes.last < 48 || input.runes.last > 57) {
      controller.text = input.substring(0, input.length - 1);
    } else {
      switch (input.length) {
        case 1:
          if (_parseInt(input) > 3) {
            controller.text = '0$input$seperator';
          }
          break;
        case 2:
          if (_parseInt(input) > 31) {
            controller.text = input[0];
          }
          break;
        case 3:
          if (input[2] != seperator) {
            controller.text = int.parse(input[2]) <= 1
                ? '${input.substring(0, 2)}$seperator${input[2]}'
                : '${input.substring(0, 2)}${seperator}0${input[2]}$seperator';
          }
          break;
        case 4:
          break;
        case 5:
          if (_parseInt(input.substring(3, 5)) > 12) {
            controller.text =
                '${input.substring(0, 3)}0${input[3]}${seperator}${input[4]}';
            break;
          }
          break;
        case 6:
          if (input[5] != seperator) {
            controller.text = '${input.substring(0, 5)}$seperator${input[5]}';
          }
          break;
        default:
          if (input.length == maxLength + 1) {
            controller.text = input.substring(0, maxLength);
          }
      }
    }
    // move to the end of textfield
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  String formatNumber(int number, int desiredLength) {
    String numberString = number.toString();
    if (numberString.length >= desiredLength) {
      return numberString;
    } else {
      String padding = '0' * (desiredLength - numberString.length);
      return '$padding$numberString';
    }
  }

  void format(String input, int maxLength) {
    _typeTemplate(input, '-', maxLength);
  }

  static DateTime _parseDate(String input) {
    int day = int.parse(input.substring(0, 2));
    int month = int.parse(input.substring(3, 5));
    int year = int.parse(input.substring(6, 10));
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    if (value != null && !focusNode.hasFocus) {
      controller.text =
          '${formatNumber(value!.day, 2)}-${formatNumber(value!.month, 2)}-${formatNumber(value!.year, 4)}';
    }

    controller.addListener(() {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    });

    Color color = Colors.black;
    FontWeight fontWeight = FontWeight.normal;
    switch (state) {
      case _FieldState.error:
        color = Theme.of(context).colorScheme.error;
        break;
      case _FieldState.valid:
        color = Theme.of(context).colorScheme.primary;
        fontWeight = FontWeight.bold;
        break;
      default:
    }

    return TextField(
      focusNode: focusNode,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontWeight: fontWeight),
      controller: controller,
      keyboardType: TextInputType.datetime,
      onChanged: (value) {
        const maxLength = 10;
        format(value, maxLength);
        if (value.length == maxLength) {
          onComplete(_parseDate(value));
        }
        updateFields();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _CustomDurataionField extends StatelessWidget {
  _FieldState state;
  void Function(int?) onComplete;
  String hintText;
  int? value;
  final TextEditingController controller;
  final FocusNode focusNode;
  _CustomDurataionField({
    super.key,
    required this.state,
    required this.onComplete,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.value,
  });

  void format(String input) {
    if (input.isEmpty) {
    } else if (input.runes.last < 48 || input.runes.last > 57) {
      controller.text = input.substring(0, input.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    FontWeight fontWeight = FontWeight.normal;
    switch (state) {
      case _FieldState.error:
        color = Theme.of(context).colorScheme.error;
        break;
      case _FieldState.valid:
        color = Theme.of(context).colorScheme.primary;
        fontWeight = FontWeight.bold;
        break;
      default:
    }

    if (value != null) {
      controller.text = value.toString();
    }

    return TextField(
      focusNode: focusNode,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontWeight: fontWeight),
      controller: controller,
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        onComplete(int.parse(value));
      },
      onChanged: (value) {
        format(value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.normal),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

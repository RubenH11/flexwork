import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/user/new_reservation/menu.dart";
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import '../../widgets/customTextButton.dart';
import "package:provider/provider.dart";
import "package:intl/intl.dart";

class NewReservationMenuTimeFrame extends StatefulWidget {
  const NewReservationMenuTimeFrame({super.key});

  @override
  State<NewReservationMenuTimeFrame> createState() =>
      _NewReservationTimeFrameState();
}

enum _DisplayOption {
  none,
  onlyStart,
  onlyEnd,
}

class _NewReservationTimeFrameState extends State<NewReservationMenuTimeFrame> {
  DateTime? previousEndTime;
  _DisplayOption displayOption = _DisplayOption.none;

  void setDisplayOption(_DisplayOption disOp) {
    setState(() {
      displayOption = disOp;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("|||| NewReservationMenuTimeFrame ||||");

    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);


    if (newReservationNotifier.getEndTime() == null &&
        newReservationNotifier.getStartTime() == null) {
      displayOption = _DisplayOption.none;
    }

    return MenuItem(
      icon: Icon(Icons.access_time),
      title: "Timeframe",
      child: Column(
        children: [
          MenuAction(
            label: "Start",
            action: Consumer<NewReservationNotifier>(
              builder: (ctx, newResNotif, _) => CustomTextButton(
                onPressed: () {
                  final startTime = newResNotif.getStartTime();
                  final endTime = newResNotif.getEndTime();

                  if (startTime != null && endTime == null) {
                    newResNotif.setStartTime(endTime);
                  } else if (startTime == null && endTime == null) {
                    newResNotif.setStartTime(roundToNext15(DateTime.now()));
                  }

                  setDisplayOption(_DisplayOption.onlyStart);
                },
                selected: true,
                text: newResNotif.getStartTime() == null
                    ? "no date selected"
                    : DateFormat("dd MMM yyyy - HH:mm").format(
                        newResNotif.getStartTime()!,
                      ),
              ),
            ),
          ),
          if (displayOption == _DisplayOption.onlyStart)
            Selector(
              selector: (p0, p1) => 0,
              builder: (_, __, ___) => DatePicker(
                aboveMenuBase: "end",
                aboveMenuOptions: [-30, -60, -120],
                releaseDisplay: () => setDisplayOption(_DisplayOption.none),
                getInitialDateTime: () {
                  print("end time: ${newReservationNotifier.getEndTime()}");
                  if (newReservationNotifier.getStartTime() != null) {
                    print("?");
                    return newReservationNotifier.getStartTime();
                  } else if (newReservationNotifier.getEndTime() != null) {
                    return newReservationNotifier.getEndTime();
                  } else {
                    return roundToNext15(DateTime.now());
                  }
                },
                getMinimumDate: () => null,
                getMaximumDate: () => newReservationNotifier.getEndTime(),
                onDateTimeChanged: (DateTime newDate) {
                  print("765446");
                  newReservationNotifier.setStartTime(newDate);
                },
                getTime: newReservationNotifier.getStartTime,
                setTime: newReservationNotifier.setStartTime,
              ),
            ),
          MenuAction(
            label: "End",
            action: Consumer<NewReservationNotifier>(
              builder: (ctx, newResNotif, _) => CustomTextButton(
                onPressed: () {
                  final startTime = newResNotif.getStartTime();
                  final endTime = newResNotif.getEndTime();

                  if (startTime != null && endTime == null) {
                    newResNotif.setEndTime(startTime);
                  } else if (startTime == null && endTime == null) {
                    newResNotif.setEndTime(roundToNext15(DateTime.now()));
                  }

                  setDisplayOption(_DisplayOption.onlyEnd);
                },
                selected: true,
                text: newResNotif.getEndTime() == null
                    ? "no date selected"
                    : DateFormat("dd MMM yyyy - HH:mm").format(
                        newResNotif.getEndTime()!,
                      ),
              ),
            ),
          ),
          if (displayOption == _DisplayOption.onlyEnd)
            Selector(
              selector: (p0, p1) => 0,
              builder: (_, __, ___) => DatePicker(
                aboveMenuBase: "start",
                aboveMenuOptions: [30, 60, 120],
                releaseDisplay: () => setDisplayOption(_DisplayOption.none),
                getInitialDateTime: () =>
                    newReservationNotifier.getEndTime() ??
                    newReservationNotifier.getStartTime() ??
                    roundToNext15(DateTime.now()),
                getMinimumDate: () => newReservationNotifier.getStartTime(),
                getMaximumDate: () => null,
                onDateTimeChanged: (DateTime newDate) {
                  newReservationNotifier.setEndTime(newDate);
                },
                getTime: newReservationNotifier.getEndTime,
                setTime: newReservationNotifier.setEndTime,
              ),
            ),
        ],
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  List<int> aboveMenuOptions;
  String aboveMenuBase;
  void Function() releaseDisplay;
  DateTime? Function() getInitialDateTime;
  void Function(DateTime) onDateTimeChanged;
  DateTime? Function() getMinimumDate;
  DateTime? Function()? getMaximumDate;
  DateTime? Function() getTime;
  void Function(DateTime?) setTime;

  DatePicker({
    this.aboveMenuOptions = const [],
    this.aboveMenuBase = "start",
    required this.releaseDisplay,
    required this.getInitialDateTime,
    required this.getMinimumDate,
    required this.onDateTimeChanged,
    required this.getTime,
    required this.setTime,
    this.getMaximumDate,
    super.key,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    print("|||| DatePicker ||||");
    void updateDatePicker() {
      setState(() {});
    }

    return Column(
      children: [
        _DatePickerPresetButtons(widget.aboveMenuOptions, widget.aboveMenuBase),
        _DatePickerButtons(
          releaseDisplay: widget.releaseDisplay,
          updateDatePicker: updateDatePicker,
          getTime: widget.getTime,
          setTime: widget.setTime,
        ),
        // picker interface
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            key: UniqueKey(),
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            initialDateTime: widget.getInitialDateTime(),
            onDateTimeChanged: widget.onDateTimeChanged,
            minimumDate: widget.getMinimumDate(),
            maximumDate:
                widget.getMaximumDate == null ? null : widget.getMaximumDate!(),
            minuteInterval: 15,
          ),
        ),
      ],
    );
  }
}

class _DatePickerButtons extends StatefulWidget {
  Function() releaseDisplay;
  Function updateDatePicker;
  DateTime? Function() getTime;
  void Function(DateTime?) setTime;
  _DatePickerButtons(
      {required this.releaseDisplay,
      required this.updateDatePicker,
      required this.getTime,
      required this.setTime,
      super.key});

  @override
  State<_DatePickerButtons> createState() => _DatePickerButtonsState();
}

class _DatePickerButtonsState extends State<_DatePickerButtons> {
  @override
  Widget build(BuildContext context) {
    print("|||| DatePickerButtons ||||");
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    final previousStartTime = widget.getTime();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: () {
              widget.releaseDisplay();
              widget.setTime(previousStartTime);
            },
            text: "cancel",
            active: true,
            selected: false,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: CustomTextButton(
            onPressed: () {
              print("76453");
              widget.setTime(changeTimeToToday(widget.getTime()));
              widget.updateDatePicker();
            },
            text: "today",
            selected: widget.getTime() != null &&
                widget.getTime()!.day == DateTime.now().day,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: CustomElevatedButton(
            onPressed: () => widget.releaseDisplay(),
            active: true,
            selected: false,
            text: "done",
          ),
        ),
      ],
    );
  }
}

class _DatePickerPresetButtons extends StatelessWidget {
  final List<int> options;
  final String base;
  const _DatePickerPresetButtons(this.options, this.base, {super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| DatePickerPresetButtons ||||");
    final newResNotif = Provider.of<NewReservationNotifier>(context);

    List<Widget> buttons = [];
    DateTime? baseTime;

    if (base == "start") {
      baseTime = newResNotif.getStartTime();
    } else if (base == "end") {
      baseTime = newResNotif.getEndTime();
    } else {
      throw ErrorDescription("base was not start nor end");
    }

    if (baseTime != null) {
      options.forEach((option) {
        String text;
        if (option < 60) {
          text = "$option min.";
        } else if (option == 60) {
          text = "1 hour";
        } else {
          text = "${(option / 60).ceil()} hours";
        }

        buttons.add(Expanded(
          child: CustomTextButton(
            onPressed: () {
              // print("add $option minutes");
              if (base == "start") {
                newResNotif.setEndTime(
                  baseTime!.add(Duration(minutes: option)),
                );
              } else {
                newResNotif.setStartTime(
                  baseTime!.add(Duration(minutes: option)),
                );
              }
            },
            selected: base == "start"
                ? newResNotif.getEndTime() ==
                    baseTime!.add(Duration(minutes: option))
                : newResNotif.getStartTime() ==
                    baseTime!.add(Duration(minutes: option)),
            text: text,
          ),
        ));
      });
    }

    for (var i = buttons.length - 1; i > 0; i--) {
      buttons.insert(i, SizedBox(width: 5));
    }

    return Row(children: buttons);
  }
}

// helpers
DateTime roundToNext15(DateTime dateTimeToRound) {
  final minutesToAdd = 15 - dateTimeToRound.minute % 15;
  final roundedDateTime = dateTimeToRound
      .add(Duration(minutes: minutesToAdd == 15 ? 0 : minutesToAdd))
      .subtract(Duration(
          seconds: dateTimeToRound.second,
          milliseconds: dateTimeToRound.millisecond,
          microseconds: dateTimeToRound.microsecond));
  return roundedDateTime;
}

DateTime onlyChangeDay(DateTime dateTimeToChange, DateTime day) {
  //print("going from $dateTimeToChange to $day");
  final newDate = dateTimeToChange
      .subtract(Duration(days: dateTimeToChange.day))
      .add(Duration(days: day.day));
  //print("resulted in $newDate");
  return newDate;
}

DateTime changeTimeToToday(DateTime? timeToBeChanged) {
  DateTime newTime;

  // if no time is set yet
  if (timeToBeChanged == null) {
    // print("==no time was set");
    return roundToNext15(DateTime.now());
  }

  // if returning to today would cause the datepicker to go before its minimum
  if (timeToBeChanged.hour < DateTime.now().hour ||
      (timeToBeChanged.hour == DateTime.now().hour &&
          timeToBeChanged.minute < DateTime.now().minute)) {
    // print("==time was before minimum");
    return roundToNext15(DateTime.now());
  }

  // print("==no issues");
  return onlyChangeDay(timeToBeChanged, DateTime.now());
}

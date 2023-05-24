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
    final newReservationNotifier =
        Provider.of<NewReservationNotifier>(context, listen: false);

    return MenuItem(
      icon: Icon(Icons.access_time),
      title: "Timeframe",
      child: Column(
        children: [
          MenuAction(
            label: "Start",
            action: CustomTextButton(
              onPressed: () {
                if (newReservationNotifier.getStartTime() == null) {
                  newReservationNotifier
                      .setStartTime(roundToNext15(DateTime.now()));
                }
                setDisplayOption(_DisplayOption.onlyStart);
              },
              selected: true,
              text: newReservationNotifier.getStartTime() == null
                  ? "no date selected"
                  : DateFormat("dd MMM yyyy - HH:mm").format(
                      newReservationNotifier.getStartTime()!,
                    ),
            ),
          ),
          if (displayOption == _DisplayOption.onlyStart)
            DatePicker(
              releaseDisplay: () => setDisplayOption(_DisplayOption.none),
              getInitialDateTime: () => roundToNext15(
                  newReservationNotifier.getStartTime() ?? DateTime.now()),
              getMinimumDate: () =>
                  roundToNext15(DateTime.now()).subtract(Duration(minutes: 15)),
              getMaximumDate: () => newReservationNotifier.getEndTime(),
              onDateTimeChanged: (DateTime newDate) {
                newReservationNotifier.setStartTime(newDate);
              },
              getTime: newReservationNotifier.getStartTime,
              setTime: newReservationNotifier.setStartTime,
            ),
          MenuAction(
            label: "End",
            action: CustomTextButton(
              onPressed: () {
                final startTime = newReservationNotifier.getStartTime();
                final endTime = newReservationNotifier.getEndTime();

                if (startTime != null && endTime == null) {
                  newReservationNotifier.setEndTime(startTime);
                } else if (startTime == null && endTime == null) {
                  newReservationNotifier
                      .setEndTime(roundToNext15(DateTime.now()));
                }

                setDisplayOption(_DisplayOption.onlyEnd);
              },
              selected: true,
              text: newReservationNotifier.getEndTime() == null
                  ? "no date selected"
                  : DateFormat("dd MMM yyyy - HH:mm").format(
                      newReservationNotifier.getEndTime()!,
                    ),
            ),
          ),
          if (displayOption == _DisplayOption.onlyEnd)
            DatePicker(
              releaseDisplay: () => setDisplayOption(_DisplayOption.none),
              getInitialDateTime: () => roundToNext15(
                  newReservationNotifier.getEndTime() ??
                      newReservationNotifier.getStartTime() ??
                      roundToNext15(DateTime.now())
                          .subtract(const Duration(minutes: 15))),
              getMinimumDate: () =>
                  newReservationNotifier.getStartTime() ??
                  roundToNext15(DateTime.now())
                      .subtract(const Duration(minutes: 15)),
              onDateTimeChanged: (DateTime newDate) {
                newReservationNotifier.setEndTime(newDate);
              },
              getTime: newReservationNotifier.getEndTime,
              setTime: newReservationNotifier.setEndTime,
            ),
        ],
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  void Function() releaseDisplay;
  DateTime? Function() getInitialDateTime;
  void Function(DateTime) onDateTimeChanged;
  DateTime? Function() getMinimumDate;
  DateTime? Function()? getMaximumDate;
  DateTime? Function() getTime;
  void Function(DateTime?) setTime;

  DatePicker({
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
    void updateDatePicker() {
      setState(() {});
    }

    return Column(
      children: [
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
              widget.setTime(changeTimeToToday(widget.getTime()));
              widget.updateDatePicker();
            },
            text: "today",
            selected: widget.getTime != null &&
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
    print("==no time was set");
    return roundToNext15(DateTime.now());
  }

  // if returning to today would cause the datepicker to go before its minimum
  if (timeToBeChanged.hour < DateTime.now().hour ||
      (timeToBeChanged.hour == DateTime.now().hour &&
          timeToBeChanged.minute < DateTime.now().minute)) {
    print("==time was before minimum");
    return roundToNext15(DateTime.now());
  }

  print("==no issues");
  return onlyChangeDay(timeToBeChanged, DateTime.now());
}

import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/widgets/plainElevatedButton.dart";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "./newResMenu.dart";
import "../widgets/plainTextButton.dart";
import "package:provider/provider.dart";
import "package:intl/intl.dart";

class NewReservationTimeFrame extends StatefulWidget {
  const NewReservationTimeFrame({super.key});

  @override
  State<NewReservationTimeFrame> createState() =>
      _NewReservationTimeFrameState();
}

enum _DisplayOption {
  none,
  onlyStart,
  onlyEnd,
}

class _NewReservationTimeFrameState extends State<NewReservationTimeFrame> {
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

    return Column(
      children: [
        Row(children: const [
          Icon(Icons.access_time),
          SizedBox(width: 10),
          Text("Timeframe")
        ]),
        const SizedBox(height: 5),
        //Start
        _StartDateSelection(
            takeDisplay: () => setDisplayOption(_DisplayOption.onlyStart)),
        if (displayOption == _DisplayOption.onlyStart)
          DatePicker(
            releaseDisplay: () => setDisplayOption(_DisplayOption.none),
            getInitialDateTime: () => roundToNext15(newReservationNotifier.getStartTime() ?? DateTime.now()),
            getMinimumDate: () =>
                roundToNext15(DateTime.now()).subtract(Duration(minutes: 15)),
            getMaximumDate: () => newReservationNotifier.getEndTime(),
            onDateTimeChanged: (DateTime newDate) {
              newReservationNotifier.setStartTime(newDate);
            },
            getTime: newReservationNotifier.getStartTime,
            setTime: newReservationNotifier.setStartTime,
          ),
        //End
        _EndDateSelection(
            takeDisplay: () => setDisplayOption(_DisplayOption.onlyEnd)),
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
    );
  }
}

class _StartDateSelection extends StatelessWidget {
  Function() takeDisplay;
  _StartDateSelection({required this.takeDisplay, super.key});

  @override
  Widget build(BuildContext context) {
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    return MenuItem(
        labelText: "Start",
        child: PlainTextButton(
          onPressed: () {
            if (newReservationNotifier.getStartTime() == null) {
              newReservationNotifier
                  .setStartTime(roundToNext15(DateTime.now()));
            }
            takeDisplay();
          },
          selected: true,
          text: newReservationNotifier.getStartTime() == null
              ? "no date selected"
              : DateFormat('HH:mm - dd MMM yyyy')
                  .format(newReservationNotifier.getStartTime()!),
        ));
  }
}

class _EndDateSelection extends StatelessWidget {
  Function() takeDisplay;
  _EndDateSelection({required this.takeDisplay, super.key});

  @override
  Widget build(BuildContext context) {
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    return MenuItem(
        labelText: "End",
        child: PlainTextButton(
          onPressed: () {
            final startTime = newReservationNotifier.getStartTime();
            final endTime = newReservationNotifier.getEndTime();

            if (startTime != null && endTime == null) {
              newReservationNotifier.setEndTime(startTime);
            } else if (startTime == null && endTime == null) {
              newReservationNotifier.setEndTime(roundToNext15(DateTime.now()));
            }

            takeDisplay();
          },
          selected: true,
          text: newReservationNotifier.getEndTime() == null
              ? "no date selected"
              : DateFormat('HH:mm - dd MMM yyyy')
                  .format(newReservationNotifier.getEndTime()!),
        ));
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
          child: PlainElevatedButton(
            onPressed: () {
              widget.releaseDisplay();
              widget.setTime(previousStartTime);
            },
            child: Text("cancel"),
            focused: false,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: PlainTextButton(
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
          child: PlainElevatedButton(
              onPressed: () => widget.releaseDisplay(),
              focused: false,
              child: Text("done")),
        ),
      ],
    );
  }
}

// helpers
DateTime roundToNext15(DateTime dateTimeToRound) {
  final minutesToAdd = 15 - dateTimeToRound.minute % 15;
  final roundedDateTime =
      dateTimeToRound.add(Duration(minutes: minutesToAdd == 15 ? 0 : minutesToAdd)).subtract(Duration(seconds: dateTimeToRound.second, milliseconds: dateTimeToRound.millisecond, microseconds: dateTimeToRound.microsecond));
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

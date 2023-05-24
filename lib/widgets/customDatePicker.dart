import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";

class CustomDatePicker extends StatefulWidget {
  final Function onTapOutside;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime initialFocusedDay;
  final Function(DateTime) onDaySelected;
  final DateTime? Function()? getSelectedDay;
  final List<DateTime>? markedDates;

  const CustomDatePicker({
    required this.initialFocusedDay,
    required this.onTapOutside,
    required this.firstDay,
    required this.lastDay,
    required this.onDaySelected,
    this.getSelectedDay,
    this.markedDates,
    super.key,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _focusedDay = widget.initialFocusedDay;
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    _focusedDay = widget.initialFocusedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) => widget.onTapOutside(),
      child: TableCalendar(
        calendarBuilders: widget.markedDates == null
            ? const CalendarBuilders()
            : CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  for (final markedDate in widget.markedDates!) {
                    if (day.day == markedDate.day &&
                        day.month == markedDate.month &&
                        day.year == markedDate.year) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                          
                          height: 25,
                          width: 25,
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}', style: TextStyle(color: Theme.of(context).colorScheme.onError, fontSize: 14),
                          ),
                        ),
                      );
                    }
                  }
                  return null;
                },
              ),
        key: _calendarKey,
        focusedDay: _focusedDay,
        firstDay: widget.firstDay,
        lastDay: widget.lastDay,
        rowHeight: 40,
        headerStyle: HeaderStyle(
            titleTextStyle: Theme.of(context).textTheme.bodyMedium!,
            titleCentered: true),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle),
          todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              shape: BoxShape.circle),
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: "month",
        },
        onDaySelected: (selectedDay, _) {
          // print("day selected");
          widget.onDaySelected(selectedDay);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        selectedDayPredicate: widget.getSelectedDay == null
            ? null
            : (day) {
                return day == widget.getSelectedDay!();
              },
      ),
    );
  }
}

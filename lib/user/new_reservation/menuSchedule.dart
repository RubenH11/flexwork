import "package:dropdown_button2/dropdown_button2.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/user/new_reservation/menu.dart";
import "package:flexwork/widgets/customDatePicker.dart";
import "package:flexwork/widgets/customElevatedButton.dart";
import "package:flexwork/widgets/customTextButton.dart";
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class NewReservationMenuSchedule extends StatefulWidget {
  const NewReservationMenuSchedule({super.key});

  @override
  State<NewReservationMenuSchedule> createState() =>
      _NewReservationMenuScheduleState();
}

class _NewReservationMenuScheduleState
    extends State<NewReservationMenuSchedule> {
  late bool untilDatePickerIsOpen;
  late bool exceptDatePickerIsOpen;
  var scheduleMenuIsClosed = true;

  @override
  void initState() {
    print("init");
    untilDatePickerIsOpen = false;
    exceptDatePickerIsOpen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("3: $untilDatePickerIsOpen");
    final newResNotif =
        Provider.of<NewReservationNotifier>(context, listen: false);

    final scheduleExceptions = newResNotif.getScheduleExceptions();

    return scheduleMenuIsClosed
        ? CustomElevatedButton(
            onPressed: () {
              setState(() {
                scheduleMenuIsClosed = false;
              });
            },
            active: true,
            selected: false,
            icon: Icons.add,
            text: "Configure schedule",
          )
        : MenuItem(
            icon: Icon(Icons.calendar_today),
            title: "Schedule",
            trailing: IconButton(
              icon: Icon(Icons.close),
              splashRadius: 20,
              onPressed: () {
                setState(() {
                  newResNotif.clearSchedule();
                  scheduleMenuIsClosed = true;
                });
              },
            ),
            child: Column(
              children: [
                MenuAction(
                  label: "Repeat",
                  action: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "every",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 60,
                        child: _ScheduleTimeFrameNumField(),
                      ),
                      Expanded(
                        child: _ScheduleTimeframeDropown(),
                      ),
                    ],
                  ),
                ),
                MenuAction(
                  label: "Until",
                  action: CustomTextButton(
                    onPressed: () {
                      if (!untilDatePickerIsOpen) {
                        setState(() {
                          untilDatePickerIsOpen = true;
                          print("1: $untilDatePickerIsOpen");
                        });
                      }
                    },
                    selected: true,
                    text: newResNotif.getScheduleUntilDate() == null
                        ? "Select date"
                        : DateFormat("dd MMM yyyy").format(
                            newResNotif.getScheduleUntilDate()!,
                          ),
                  ),
                ),
                if (untilDatePickerIsOpen)
                  CustomDatePicker(
                    initialFocusedDay: newResNotif.getStartTime()!,
                    onTapOutside: () {
                      setState(() {
                        untilDatePickerIsOpen = false;
                      });
                    },
                    firstDay: newResNotif.getStartTime()!,
                    lastDay: newResNotif
                        .getStartTime()!
                        .add(const Duration(days: 9000)),
                    getSelectedDay: newResNotif.getScheduleUntilDate,
                    onDaySelected: (date) {
                      setState(() {
                        untilDatePickerIsOpen = false;
                      });
                      newResNotif.setScheduleUntilDate(date);
                    },
                  ),
                MenuAction(
                  label: "Except",
                  action: CustomElevatedButton(
                    active: newResNotif.getScheduleUntilDate() != null,
                    selected: false,
                    onPressed: () {
                      setState(() {
                        exceptDatePickerIsOpen = true;
                      });
                    },
                    icon: Icons.add,
                    text: "add a date",
                  ),
                ),
                if (exceptDatePickerIsOpen)
                  CustomDatePicker(
                    initialFocusedDay: newResNotif.getStartTime()!,
                    onTapOutside: () {
                      setState(() {
                        exceptDatePickerIsOpen = false;
                      });
                    },
                    firstDay: newResNotif.getStartTime()!,
                    lastDay: newResNotif.getScheduleUntilDate()!,
                    onDaySelected: (date) {
                      setState(() {
                        if (scheduleExceptions.contains(date)) {
                          newResNotif.removeScheduleException(date);
                          print("removed $date");
                        } else {
                          newResNotif.addManualScheduleException(date);
                          print("added $date");
                        }
                      });
                    },
                    markedDates: scheduleExceptions,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: scheduleExceptions.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // CustomTextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       newResNotif.removeScheduleException(
                          //           scheduleExceptions[index]);
                          //     });
                          //   },
                          //   icon: Icons.delete,
                          //   width: 45,
                          //   selected: false,
                          //   color: Theme.of(context).colorScheme.onBackground,
                          // ),
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: Text(
                                DateFormat("dd MMM yyyy").format(
                                  scheduleExceptions[index],
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

class _ScheduleTimeFrameNumField extends StatefulWidget {
  const _ScheduleTimeFrameNumField({super.key});

  @override
  State<_ScheduleTimeFrameNumField> createState() =>
      __ScheduleTimeFrameNumFieldState();
}

class __ScheduleTimeFrameNumFieldState
    extends State<_ScheduleTimeFrameNumField> {
  var scheduleTimeframeNumIsZero = false;
  final scheduleTimeframeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newResNotif = Provider.of<NewReservationNotifier>(context);
    scheduleTimeframeController.text =
        newResNotif.getScheduleTimeframeNum().toString();
    final scheduleTimeframeFocusNode = FocusNode();

    void confirmScheduleTimeframeNum() {
      final value = scheduleTimeframeController.text;
      if (value == "" || value == "0") {
        setState(() {
          scheduleTimeframeNumIsZero = true;
        });
      } else {
        newResNotif.setScheduleTimeframeNum(
          int.parse(scheduleTimeframeController.text),
        );
        setState(() {
          scheduleTimeframeNumIsZero = false;
        });
      }

      scheduleTimeframeFocusNode.unfocus();
    }

    return TextField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      focusNode: scheduleTimeframeFocusNode,
      controller: scheduleTimeframeController,
      style: Theme.of(context).textTheme.bodyMedium!.merge(
            TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: scheduleTimeframeNumIsZero
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onBackground),
            borderRadius: BorderRadius.zero),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheduleTimeframeNumIsZero
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      textAlign: TextAlign.center,
      onTapOutside: (_) => confirmScheduleTimeframeNum(),
      onEditingComplete: confirmScheduleTimeframeNum,
    );
  }
}

class _ScheduleTimeframeDropown extends StatelessWidget {
  const _ScheduleTimeframeDropown({super.key});

  @override
  Widget build(BuildContext context) {
    // print("rebuild _ScheduleTimeframeDropown");
    final focusNode = FocusNode();
    final newResNotif = Provider.of<NewReservationNotifier>(context);
    final options = NewReservationNotifier.getScheduleTimeframeOptions();
    final selectedOption = newResNotif.getScheduleTimeframe() ?? "months";

    final selectedColor = Theme.of(context).colorScheme.primary;
    final dropDownColor = Theme.of(context).colorScheme.onSecondary;

    final menuItems = options.map(
      (option) {
        return DropdownMenuItem(
          value: option,
          child: Center(
              child: Text(option, style: TextStyle(color: dropDownColor))),
        );
      },
    ).toList();

    return DropdownButton2(
      onMenuStateChange: (isOpen) {
        if (isOpen) {
          focusNode.unfocus();
        }
      },
      focusNode: focusNode,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
      alignment: Alignment.center,
      iconStyleData: IconStyleData(iconSize: 0),
      underline: SizedBox(),
      isDense: true,
      isExpanded: true,
      buttonStyleData: const ButtonStyleData(height: 30),
      menuItemStyleData: MenuItemStyleData(
        height: 30,
        selectedMenuItemBuilder: (context, child) =>
            Container(color: Theme.of(context).colorScheme.background, child: child),
      ),
      dropdownStyleData: DropdownStyleData(
        width: 100,
        offset: const Offset(-15, 0),
        elevation: 0,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.background),
        ),
      ),
      value: selectedOption,
      items: menuItems,
      selectedItemBuilder: (_) => options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Center(
              child: Text(option, style: TextStyle(color: selectedColor))),
        );
      }).toList(),
      onChanged: (value) {
        print("selected $value");
        newResNotif.setScheduleTimeframe(value);
      },
    );
  }
}

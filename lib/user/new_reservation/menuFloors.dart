import "package:flexwork/models/newReservationNotifier.dart";
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'menu.dart';
import '../../widgets/customTextButton.dart';
import '../../models/floors.dart';

class NewReservationMenuFloors extends StatefulWidget {
  const NewReservationMenuFloors({super.key});

  @override
  State<NewReservationMenuFloors> createState() => _NewReservationFloorsState();
}

class _NewReservationFloorsState extends State<NewReservationMenuFloors> {
  @override
  Widget build(BuildContext context) {
    print("|||| NewReservationMenuFloors ||||");
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    return MenuItem(
      icon: Icon(Icons.apartment),
      title: "Floors",
      child: Column(
        children: [
          CustomTextButton(
            textAlign: TextAlign.left,
            text: "Floor 12",
            selected: newReservationNotifier.getFloor() == Floors.f12,
            onPressed: () {
              if (newReservationNotifier.getFloor() != Floors.f12) {
                newReservationNotifier.setFloor(Floors.f12);
              }
            },
          ),
          CustomTextButton(
            textAlign: TextAlign.left,
            text: "Floor 11",
            selected: newReservationNotifier.getFloor() == Floors.f11,
            onPressed: () {
              if (newReservationNotifier.getFloor() != Floors.f11) {
                newReservationNotifier.setFloor(Floors.f11);
              }
            },
          ),
          CustomTextButton(
            textAlign: TextAlign.left,
            text: "Floor 10",
            selected: newReservationNotifier.getFloor() == Floors.f10,
            onPressed: () {
              if (newReservationNotifier.getFloor() != Floors.f10) {
                newReservationNotifier.setFloor(Floors.f10);
              }
            },
          ),
          CustomTextButton(
            textAlign: TextAlign.left,
            text: "Floor 9",
            selected: newReservationNotifier.getFloor() == Floors.f9,
            onPressed: () {
              if (newReservationNotifier.getFloor() != Floors.f9) {
                newReservationNotifier.setFloor(Floors.f9);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _FloorButton extends StatelessWidget {
  final String label;
  final Function() setFloor;
  final bool isSelected;
  const _FloorButton(this.label, this.setFloor, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| _FloorButton ||||");
    return CustomTextButton(
      textAlign: TextAlign.left,
      text: label,
      selected: isSelected,
      onPressed: () {
        if (!isSelected) {
          setFloor();
        }
      },
    );
  }
}

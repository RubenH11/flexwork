import "../../widgets/menu_item.dart";
import "package:flutter/material.dart";
import "../../models/newSpaceNotifier.dart";
import "package:tuple/tuple.dart";
import "package:number_text_input_formatter/number_text_input_formatter.dart";

class NewSpaceMenuInfiniteCoordinates extends StatelessWidget {
  final NewSpaceNotifier newSpace;
  final FocusNode newSpaceFocusNode;
  const NewSpaceMenuInfiniteCoordinates({
    required this.newSpace,
    required this.newSpaceFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coords = newSpace.coordinates;

    return Expanded(
        child: ListView.builder(
      itemBuilder: (_, index) {
        return MenuItem(
          icon: Icon(Icons.data_array),
          title: "Coordinate ${index + 1}",
          child: Column(
            children: [
              CoordinateTextField(
                title: "X",
                value: coords[index].item1,
              ),
              CoordinateTextField(
                title: "Y",
                value: coords[index].item2,
              ),
            ],
          ),
        );
      },
      itemCount: coords.length,
    ));
  }
}

class CoordinateTextField extends StatelessWidget {
  final String title;
  final _controller = TextEditingController();
  final double value;
  CoordinateTextField({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    _controller.text = value.toString();
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(title),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            inputFormatters: [
              NumberTextInputFormatter(
                integerDigits: 10,
                maxValue: '100000.00',
                decimalSeparator: '.',
                groupDigits: 3,
                groupSeparator: ' ',
                allowNegative: false,
                overrideDecimalPoint: true,
                insertDecimalPoint: false,
                insertDecimalDigits: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

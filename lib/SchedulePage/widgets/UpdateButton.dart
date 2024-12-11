import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key, required this.value, required this.label, required this.displayValue, required this.onPressedUp, required this.onPressedDown, this.width=240});
  final String value;
  final String label;
  final String displayValue;
  final Function() onPressedUp;
  final Function() onPressedDown;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onPressedDown, icon: const Icon(Icons.keyboard_arrow_down_sharp)),
            const Spacer(),
            customText("$label : ",12, FontWeight.w700 , Colors.green, 1),
            customText(displayValue,14, FontWeight.w700 , Colors.green, 1),
            const Spacer(),
            IconButton(onPressed: onPressedUp, icon: const Icon(Icons.keyboard_arrow_up_sharp)),


          ],
        ),
      ),
    );
  }
}

class UpdateButton2 extends StatelessWidget {
  const UpdateButton2({super.key, required this.value, required this.displayValue, required this.onPressedUp, required this.onPressedDown, this.width=240});
  final String value;
  final String displayValue;
  final Function() onPressedUp;
  final Function() onPressedDown;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onPressedDown, icon: const Icon(Icons.keyboard_arrow_down_sharp)),
            const Spacer(),
            customText(displayValue,14, FontWeight.w700 , Colors.green, 1),
            const Spacer(),
            IconButton(onPressed: onPressedUp, icon: const Icon(Icons.keyboard_arrow_up_sharp)),


          ],
        ),
      ),
    );
  }
}
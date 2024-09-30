import 'package:flutter/material.dart';

import '../../SchedulePage/widgets/widgets.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
class NavButton extends StatefulWidget {
  const NavButton({super.key, required this.onTap, required this.isActive, required this.text, required this.icon});
  final Function() onTap;
  final bool isActive;
  final String text;
  final IconData icon;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Adjust the duration as needed
        padding: const EdgeInsets.symmetric(vertical:10 , horizontal: 10),
        decoration: BoxDecoration(
          color: widget.isActive ? blueColor : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: widget.isActive
                  ? dark? darkBlueColor :blueColor.withOpacity(0.4)
                  : Colors.grey.withOpacity(0),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isActive ? darkBlueColor: dark? Colors.white:yellowColor,
              size: 25,
            ),
            if (widget.isActive) const SizedBox(width: 3),
            if (widget.isActive)
              customText(
                widget.text,
                15,
                FontWeight.w600,
                widget.isActive ? darkBlueColor : dark? Colors.white:yellowColor,
                1,
              )
          ],
        ),
      ),
    );
  }
}
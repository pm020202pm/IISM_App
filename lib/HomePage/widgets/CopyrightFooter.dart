import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: customText("© 2024 Inter-IIT Sports Meet. All rights reserved.", 12, FontWeight.normal, Colors.grey.shade600, 1),
    );
  }
}

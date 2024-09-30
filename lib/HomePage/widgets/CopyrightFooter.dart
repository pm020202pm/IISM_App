import 'package:flutter/material.dart';
import 'package:iism/SchedulePage/widgets/widgets.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: customText("© 2024 Inter-IIT Sports Meet. All rights reserved.", 12, FontWeight.normal, dark? Colors.grey.shade100: Colors.grey.shade600, 1),
    );
  }
}

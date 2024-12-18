import 'package:flutter/material.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../pages/teams_page.dart';

class OfficialsCard extends StatelessWidget {
  const OfficialsCard({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    List<String> names = splitName(data['Name']);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipPath(
        clipper: OctagonClipper(padding: 30),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: darkBlueColor, width: 1),
            ),
            child: Container(
              width: double.infinity,
              color: yellowColor.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    ClipPath(
                        clipper: OctagonClipper(padding: 15),
                        child: Image.asset('assets/headPhotos/${names[1].toLowerCase()}.jpg', fit: BoxFit.cover, height: 90)
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(data['Name'], 16, FontWeight.w700 , darkBlueColor, 1.4),
                        customText(data['Position'], 15, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                        customText(data['Email'], 14, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}

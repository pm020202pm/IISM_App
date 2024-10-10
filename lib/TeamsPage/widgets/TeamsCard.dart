import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../pages/teams_page.dart';

class TeamsCard extends StatelessWidget {
  const TeamsCard({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    List<String> names = splitName(data['Name']);
    return InkWell(
      onTap: (){
        enlargeCoreTeamCard(context, data);
      },
      child: ClipPath(
        clipper: OctagonClipper(padding: 30),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: darkBlueColor, width: 1),
            ),
            child: Container(
              color: yellowColor.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipPath(
                        clipper: OctagonClipper(padding: 15),
                        child: Image.asset('assets/headPhotos/${names[0]}.jpg', fit: BoxFit.cover,)
                    ),
                    const SizedBox(height: 10),
                    customText(names[0].toUpperCase(), 15, FontWeight.w700 , darkBlueColor, 1),
                    if(names.length>1)customText(names[1].toUpperCase(), 12, FontWeight.w700 , darkBlueColor, 1),
                    // if(names.length>2)customText(names[2].toUpperCase(), 12, FontWeight.w700 , darkBlueColor, 1),
                    customText(formatName(data['Position']), 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
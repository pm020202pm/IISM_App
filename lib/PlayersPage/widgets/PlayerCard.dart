import 'package:flutter/material.dart';
import 'package:iism/widgets/widgets.dart';
import '../../utils.dart';
import '../models/PlayerModel.dart';
class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.playerModel});
  final PlayerModel playerModel;
  @override
  Widget build(BuildContext context) {
    List<String> sports = playerModel.sport.split("+");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          enlargeImg(context, 260, 400,playerModel.photo, Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(playerModel.name.toUpperCase(), 18, FontWeight.w700, Colors.grey.shade700, 1),
              customText(playerModel.email, 14, FontWeight.w600, Colors.grey.shade700, 1.6),
              customText(playerModel.gender, 14, FontWeight.w600, Colors.grey.shade700, 1.6),
            ],
          ));
        },
        child:  ClipPath(
          clipper: OctagonClipper(padding: 20),
          child: Container(
            color: blueColor.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipPath(
                      clipper: OctagonClipper(padding: 15),
                      child: Hero(
                          tag: playerModel.photo,
                          child: FadeInImage(
                            height: 60,
                            width: 60,
                            fadeInDuration: const Duration(milliseconds: 100),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            placeholder: const AssetImage('assets/files/shimmer.gif'),  // Placeholder image or GIF
                            image: NetworkImage(playerModel.photo),     // Actual image to be loaded
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.cover,                   // Adjust placeholder fit
                            )
                      )
                  ),
                  const SizedBox(width: 14),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(playerModel.name.toUpperCase(), 16, FontWeight.w700 , darkBlueColor, 1.4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          customText(sports[0].toUpperCase(), 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                          if(sports.length>1) customText(" | ${sports[1].toUpperCase()}", 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                          if(sports.length>2) customText(" | ${sports[2].toUpperCase()}", 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                          if(sports.length>3) customText(" | ${sports[3].toUpperCase()}", 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                        ],
                      ),
                      customText(playerModel.team.toUpperCase(), 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.2)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
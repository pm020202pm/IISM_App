import 'package:flutter/material.dart';
import 'package:iism/ProfilePage/models/ParticipantModel.dart';
import 'package:iism/widgets/widgets.dart';

import '../../utils.dart';
class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.playerModel});
  final ParticipantModel playerModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          enlargeImg(context, 260, playerModel.photo, Column(
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
                      customText(playerModel.sport.toUpperCase(), 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
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


// class PlayerCard extends StatelessWidget {
//   const PlayerCard({super.key, required this.playerModel});
//   final ParticipantModel playerModel;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         enlargeImg(context, 260, playerModel.photo, Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             customText(playerModel.name.toUpperCase(), 18, FontWeight.w700, Colors.grey.shade700, 1),
//             customText(playerModel.email, 14, FontWeight.w600, Colors.grey.shade700, 1.6),
//             customText(playerModel.gender, 14, FontWeight.w600, Colors.grey.shade700, 1.6),
//           ],
//         ));
//       },
//       child: Card(
//         elevation: 2.0,
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//         child: Padding(
//           padding: const EdgeInsets.all(6.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Hero(
//                       tag: playerModel.photo,
//                       child: FadeInImage(
//                         fadeInDuration: const Duration(milliseconds: 100),
//                         fadeOutDuration: const Duration(milliseconds: 100),
//                         placeholder: const AssetImage('assets/files/shimmer.gif'),  // Placeholder image or GIF
//                         image: NetworkImage(playerModel.photo),     // Actual image to be loaded
//                         fit: BoxFit.cover,                              // Adjust to your layout needs
//                         placeholderFit: BoxFit.cover,                   // Adjust placeholder fit
//                       )
//                   )
//               ),
//
//               const SizedBox(width: 15.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     formatName(playerModel.name),
//                     style: const TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         height: 1
//                     ),
//
//                   ),
//                   Text(playerModel.gender,
//                     style: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.w600,
//                         height: 1
//                     ),
//                   ),
//                   Text(playerModel.email,
//                     style: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.w600,
//                         height: 1.1
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



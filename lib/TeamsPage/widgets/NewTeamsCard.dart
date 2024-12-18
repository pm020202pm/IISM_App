import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../pages/teams_page.dart';


class NewTeamsCard extends StatelessWidget {
  const NewTeamsCard({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    List<String> names = splitName(data['Name']);
    String name = data['Name'].toUpperCase();

    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        enlargeCoreTeamCard(context, data);
      },
      child: ClipPath(
        clipper: OctagonClipper(padding: 15),
        child: Container(
          width: size.width-40,
          height: 65,
          color: yellowColor.withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                ClipPath(
                    clipper: OctagonClipper(padding: 15),
                    child: Image.asset('assets/headPhotos/${names[0].toLowerCase()}.jpg', fit: BoxFit.cover)
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(name, 16, FontWeight.w700 , darkBlueColor, 1.4),
                    customText(data['Email'], 14, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class AnimatedTeamsCard extends StatefulWidget {
  const AnimatedTeamsCard({super.key, this.data});
  final dynamic data;

  @override
  _AnimatedTeamsCardState createState() => _AnimatedTeamsCardState();
}

class _AnimatedTeamsCardState extends State<AnimatedTeamsCard> {
  bool _isTapped = false; // Track if the card is tapped

  @override
  Widget build(BuildContext context) {
    List<String> names = splitName(widget.data['Name']);
    double scaleFactor = _isTapped ? 2.0 : 1.0; // Scale factor for enlarged card
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
          top: _isTapped ? MediaQuery.of(context).size.height * 0.2 : 0, // Adjust position when tapped
          left: _isTapped ? MediaQuery.of(context).size.width * 0.1 : 0, // Center horizontally
          child: AnimatedScale(
            scale: scaleFactor, // Scale up when tapped
            duration: const Duration(milliseconds: 300), // Animation duration
            child: ClipPath(
              clipper: OctagonClipper(padding: 30),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isTapped = !_isTapped; // Toggle tapped state
                  });
                },
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
                            child: Image.asset(
                              'assets/headPhotos/${names[0].toLowerCase()}.jpg',
                              fit: BoxFit.cover,
                              height: 100, // Adjust image size
                              // width: 120, // Adjust image size
                            ),
                          ),
                          const SizedBox(height: 10),
                          customText(names[0].toUpperCase(), 15, FontWeight.w700, darkBlueColor, 1),
                          if (names.length > 1)
                            customText(names[1].toUpperCase(), 12, FontWeight.w700, darkBlueColor, 1),
                          customText(
                            formatName(widget.data['Position']),
                            12,
                            FontWeight.w600,
                            darkBlueColor.withOpacity(0.8),
                            1.4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

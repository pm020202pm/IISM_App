import 'package:flutter/material.dart';
import 'package:iism/widgets/widgets.dart';
class BigCard extends StatelessWidget {
  BigCard({super.key, required this.imageUrl, required this.name, required this.imageHeight, required this.imageWidth, this.position, required this.text, required this.subName, this.color, required this.radius, required this.clubName, required this.fit});
  final String imageUrl;
  final String name;
  final String subName;
  final String clubName;
  final String text;
  final double imageHeight;
  final double imageWidth;
  final double radius;
  late String? position;
  late Color? color;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.none,
        child: InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> ClubDetail(image: imageUrl, name: name, text: text, subName: subName, clubName: clubName,)));
            },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: OctagonClipper(padding: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  height: imageHeight-10,
                  width: imageWidth-10,
                  child: Hero(
                      tag: Key(imageUrl),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(16),
                          child: Image.network(imageUrl, fit: fit,)
                      )
                  ),
                ),
              ),
              ClipPath(
                clipper: OctagonClipper(padding: 160),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    // borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  height: imageHeight,
                  width: imageWidth,
                  // child: Hero(
                  //     tag: Key(imageUrl),
                  //     child: ClipRRect(
                  //         // borderRadius: BorderRadius.circular(16),
                  //         child: Image.network(imageUrl, fit: fit,)
                  //     )
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



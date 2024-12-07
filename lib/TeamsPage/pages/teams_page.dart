import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iism/TeamsPage/widgets/OfficialsCard.dart';
import '../../SchedulePage/pages/schedule_page.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../widgets/NewTeamsCard.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  int currentIndex = 0;
  double tabPadding = 10;


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = currentIndex == 0 ? officials : head;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(70),
        //   child: AppBar(
        //     backgroundColor: Colors.transparent,
        //     flexibleSpace: Container(
        //       alignment: Alignment.centerLeft,
        //       height: 80,
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 16, right: 16),
        //         child: pageTitleText("Our Team"),
        //       ),
        //     ),
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipPath(
                    clipper: OctagonClipper3(padding: 10),
                    child: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              HapticFeedback.lightImpact();
                              setState(() {
                                currentIndex = 0;
                              });
                            },
                            child: AnimatedContainer(
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all((currentIndex==0) ? tabPadding : 8.0),
                              duration: const Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (currentIndex==0) ? yellowColor : Colors.grey.shade300,
                              ),
                              child: customText("Key Officials", (currentIndex==0) ? 18 : 15, FontWeight.w600, (currentIndex==0) ? Colors.white :Colors.grey.shade600, 1),
                            ),
                          ),
                          const SizedBox(width: 3.0),
                          InkWell(
                            onTap: (){
                              HapticFeedback.lightImpact();
                              setState(() {
                                currentIndex = 1;
                              });
                            },
                            child: AnimatedContainer(
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all((currentIndex==1) ? tabPadding : 8.0),
                              duration: const Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (currentIndex==1) ? yellowColor : Colors.grey.shade300,
                              ),
                              child: customText(" Core Team ", (currentIndex==1) ? 18 : 15, FontWeight.w600, (currentIndex==1) ? Colors.white :Colors.grey.shade600, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if(currentIndex==0) OfficialsCard(data: data[0]),
                if(currentIndex==0)const SizedBox(height: 10),
                if(currentIndex==0)OfficialsCard(data: data[1]),
                if(currentIndex==0)const SizedBox(height: 10),
                if(currentIndex==0)OfficialsCard(data: data[2]),
                if(currentIndex==0)const SizedBox(height: 10),
                if(currentIndex==0)OfficialsCard(data: data[3]),
                if(currentIndex==0)const SizedBox(height: 10),
                if(currentIndex==0)OfficialsCard(data: data[4]),
                if(currentIndex==0)const SizedBox(height: 10),

                if(currentIndex==1)twoMembersCard(size, data[0], data[1], "OVERALL COORDINATORS", 180, 28,70),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)twoMembersCard(size, data[2], data[3], "WEB & APP HEADS", 125, 28,16),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)threeMembersCard(size, data[4], data[5], data[6], "SHOWM HEADS", 114, 28,8),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)twoMembersCard(size, data[7], data[8], "SECURITY HEADS", 125, 28,16),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)twoMembersCard(size, data[9], data[10], "PUBLIC RELATIONS HEADS", 174, 28,64),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)twoMembersCard(size, data[11], data[12], "MEDIA & PUBLICITY HEADS", 178, 28,66),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)oneMembersCard(size, data[13], "MARKETING HEAD", 130, 28,20),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)threeMembersCard(size, data[14], data[15], data[16],  "HOSPITALITY HEADS", 140, 28,30),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)oneMembersCard(size, data[17], "FINANCE HEADS", 125, 28,16),
                if(currentIndex==1)const SizedBox(height: 10),
                //one card finance
                if(currentIndex==1)twoMembersCard(size, data[18], data[19], "EVENTS HEADS", 112, 28,2),
                if(currentIndex==1)const SizedBox(height: 10),
                if(currentIndex==1)twoMembersCard(size, data[20], data[21], "DESIGN HEADS", 112, 28,2),
                const SizedBox(height: 70),
                // (currentIndex==1)
                // ? GridView.builder(
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 14.0,
                //     mainAxisSpacing: 18.0,
                //     childAspectRatio:0.68,
                //   ),
                //   padding: const EdgeInsets.all(16.0),
                //   itemCount: data.length,
                //   itemBuilder: (context, index) {
                //     if (index >= data.length) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     return TeamsCard(data: data[index]);
                //   },
                // )
                // : ListView.builder(
                //   padding: const EdgeInsets.all(16.0),
                //   itemCount: data.length,
                //   itemBuilder: (context, index) {
                //     if (index >= data.length) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     return Column(
                //       children: [
                //         OfficialsCard(data: data[index]),
                //         const SizedBox(height: 15),
                //       ],
                //     );
                //   },
                // ),

              ],
            ),
          ),
        )
        ,
      ),
    );
  }
}





List<String> splitName(String name) {
  List<String> names = name.split(' ');
  return names;
}
List<String> splitPosition(String name) {
  List<String> names = name.split(',');
  return names;
}


class OctagonClipper1 extends CustomClipper<Path> {
  final double padding;
  final double containerWidth;
  OctagonClipper1({required this.containerWidth, required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    // final double width = containerWidth;
    final double height = containerWidth;
    path.moveTo(0, 0); // Top-left cut
    path.lineTo(width - padding, 0); // Top-right cut
    path.lineTo(width, padding); // Right-top cut
    path.lineTo(width, height); // Right-bottom cut
    path.lineTo(padding, height); // Bottom-left cut
    path.lineTo(0, height - padding); // Left-bottom cut
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


List<Map<String, dynamic>> head=[
  {"Position": "overall coordinator", "Name": "avi sharma", "RollNo": "200230", "Email": "savi20@iitk.ac.in", "Instagram": "https://www.instagram.com/___avisharma___/", "Facebook": "https://www.facebook.com/profile.php?id=100057527562934", "Linkedin": "https://www.linkedin.com/in/sharma-avi/"},
  {"Position":"overall coordinator","Name":"mukul saini","RollNo":"210640","Email":"mukuls21@iitk.ac.in","Instagram":"https://www.instagram.com/mukul.saini63/","Facebook":"https://www.facebook.com/mukul.saini.1291","Linkedin":"https://www.linkedin.com/in/mukul-saini-40b478242/"},
  {"Position":"head , web & app","Name":"priyanshu maurya","RollNo":"220827","Email":"priyanshum22@iitk.ac.in","Instagram":"https://www.instagram.com/pm020202pm/","Facebook":"https://github.com/pm020202pm","Linkedin":"https://www.linkedin.com/in/pm020202pm/"},
  {"Position":"head , web & app","Name":"ujjawal","RollNo":"221152","Email":"ujjawal22@iitk.ac.in","Instagram":"https://www.instagram.com/_ujjwalchoudhary_/?hl=en","Facebook":"na","Linkedin":"https://www.linkedin.com/in/ujjwal-choudhary-iitkanpur/"},
  {"Position":"head , show management ","Name":"nikhil kumar sharma","RollNo":"210666","Email":"nikhilks21@iitk.ac.in","Instagram":"https://www.instagram.com/nikhilsharma.__/","Facebook":"na","Linkedin":"https://www.linkedin.com/in/nikhil-kumar-sharma-53b046252/"},
  {"Position":"head , show management ","Name":"keshav chauhan","RollNo":"210507","Email":"keshavc21@iitk.ac.in","Instagram":"https://www.instagram.com/keshav_chauhan_04/","Facebook":"https://www.facebook.com/keshav.chauhan.12720?mibextid=zbwkwl","Linkedin":"https://www.linkedin.com/in/keshav-chauhan-b02bbb231?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"},
  {"Position":"head , show management ","Name":"kartik verma","RollNo":"210497","Email":"kartikv21@iitk.ac.in","Instagram":"https://www.instagram.com/kartikv21/","Facebook":"https://www.facebook.com/profile.php?id=100075444030031","Linkedin":"na"},
  {"Position":"head , security","Name":"aakansh chandra","RollNo":"210007","Email":"aakanshc21@iitk.ac.in","Instagram":"https://www.instagram.com/aakanshchandra/","Facebook":"na","Linkedin":"www.linkedin.com/in/aakansh-chandra-43a0a6239"},
  {"Position":"head , security","Name":"mayank shekhar","RollNo":"210597","Email":"mshekhar21@iitk.ac.in","Instagram":"https://www.instagram.com/mayank___shekhar/","Facebook":"na","Linkedin":"https://www.linkedin.com/in/mayank-shekhar-a71589232?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"},
  {"Position":"head , public relations","Name":"naveen meenia","RollNo":"210655","Email":"naveenm21@iitk.ac.in","Instagram":"na","Facebook":"na","Linkedin":"https://www.linkedin.com/in/naveen-meenia-639500283/"},
  {"Position":"head , public relations","Name":"manuja pandey","RollNo":"210593","Email":"manujap21@iitk.ac.in","Instagram":"https://www.instagram.com/manujaa08/","Facebook":"na","Linkedin":"https://www.linkedin.com/in/manuja-pandey-095b26241/"},
  {"Position":"head , media & publicity ","Name":"sushant faujdar","RollNo":"211085","Email":"sushantf21@iitk.ac.in","Instagram":"https://www.instagram.com/sushant_faujdar_/","Facebook":"https://www.facebook.com/sushant.faujdar","Linkedin":"https://www.linkedin.com/in/sushantf21/"},
  {"Position":"head , media & publicity ","Name":"netraj rane","RollNo":"210664","Email":"netraj21@iitk.ac.in","Instagram":"https://www.instagram.com/netrajj?igsh=mtvkedljcgzrzzkwdq%3d%3d&utm_source=qr","Facebook":"https://www.facebook.com/profile.php?id=100074911556032","Linkedin":"https://www.linkedin.com/in/netraj-pankaj-rane-517039224/"},
  {"Position":"head , marketing","Name":"sahil","RollNo":"210893","Email":"sahil21@iitk.ac.in","Instagram":"https://www.instagram.com/_sahiljangra07/","Facebook":"https://www.facebook.com/profile.php?id=100075457655438","Linkedin":"https://www.linkedin.com/in/sahil-jangra-286257241/"},
  {"Position":"head , hospitality ","Name":"shivani","RollNo":"210985","Email":"shivani21@iitk.ac.in","Instagram":"https://www.instagram.com/shixvani__/","Facebook":"https://www.linkedin.com/in/shivani-2107a9229?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app","Linkedin":"na"},
  {"Position":"head , hospitality ","Name":"nishant patel","RollNo":"210673","Email":"nishantp21@iitk.ac.in","Instagram":"https://www.instagram.com/_nishantp_0605/","Facebook":"https://www.facebook.com/profile.php?id=100015007967815","Linkedin":"https://www.linkedin.com/in/nishant-patel-113b78231?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"},
  {"Position":"head , hospitality ","Name":"jayant nagar","RollNo":"210467","Email":"jayantn21@iitk.ac.in","Instagram":"https://www.instagram.com/jayant_.nagar/?hl=en","Facebook":"na","Linkedin":"https://www.linkedin.com/in/jayant-naagar/"},
  {"Position":"head , finance","Name":"pratham gupta","RollNo":"210754","Email":"prathamg21@iitk.c.in","Instagram":"https://www.instagram.com/prath_2995?igsh=mxruyxd2nzhqd3m2yw%3d%3d&utm_source=qr","Facebook":"null","Linkedin":"https://www.linkedin.com/in/pratham-gupta-a0b4321b8/?originalsubdomain=in"},
  {"Position":"head , events","Name":"pravesh meena","RollNo":"210764","Email":"praveshm21@iitk.ac.in","Instagram":"https://www.instagram.com/pravesh_3553/","Facebook":"https://www.facebook.com/share/1azrb9ubrn/","Linkedin":"https://www.linkedin.com/in/pravesh-meena-9b67aa229?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"},
  {"Position":"head , events","Name":"nitin garhwal","RollNo":"210678","Email":"niting21@iitk.ac.in","Instagram":"na","Facebook":"na","Linkedin":"https://www.linkedin.com/in/nitin-garhwal-03a71724b/"},
  {"Position":"head , design ","Name":"shivam rathore","RollNo":"221015","Email":"shivamr22@iitk.ac.in","Instagram":"https://www.instagram.com/shiv.wrath_04/","Facebook":"https://www.facebook.com/share/ngceb8wvmhr4lqdg/","Linkedin":"https://www.linkedin.com/in/shivam-rathore-559195259?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"},
  {"Position":"head , design ","Name":"rudraksh kawde","RollNo":"220921","Email":"rudraksh22@iitk.ac.in","Instagram":"https://www.instagram.com/asliruddu/","Facebook":"https://www.facebook.com/profile.php?id=100086966641157&mibextid=lqqj4d","Linkedin":"na"},
];

List<Map<String, dynamic>> officials = [
  {"Position": "Chairperson", "Name": "DR. PRATIK SEN", "RollNo": "", "Email": "psen@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Convener", "Name": "DR. INDRA S. SEN", "RollNo": "", "Email": "isen@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Co-Convener", "Name": "DR. ADITYA H. KELKAR", "RollNo": "", "Email": "akelkar@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Convener, Digital", "Name": "DR. SRUTI S. RAGAVAN", "RollNo": "", "Email": "srutis@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Organising Secretary", "Name": "MR. HEMANT K. TIWARI", "RollNo": "", "Email": "hktiwari@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
];

class OctagonPainter extends CustomPainter {
  final double edge;
  final Color color;
  OctagonPainter( {this.edge = 30, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Define the points for the octagon
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // Calculate the octagon's coordinates
    // final double edge = 30; // Edge size relative to width

    path.moveTo(edge, 0); // Top-left
    path.lineTo(width - edge, 0); // Top-right
    path.lineTo(width, edge); // Right-top
    path.lineTo(width, height - edge); // Right-bottom
    path.lineTo(width - edge, height); // Bottom-right
    path.lineTo(edge, height); // Bottom-left
    path.lineTo(0, height - edge); // Left-bottom
    path.lineTo(0, edge); // Left-top
    path.close();

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
class OctagonPainter2 extends CustomPainter {
  final double edge;
  final Color color;
  OctagonPainter2( {this.edge = 10, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Define the points for the octagon
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    // Calculate the octagon's coordinates
    // final double edge = 30; // Edge size relative to width

    final double chamfer = size.width * 0.2; // Adjust chamfer size as needed

    path.moveTo(0, 0); // Top-left chamfer start
    path.lineTo(width-edge, 0); // Top-right corner
    path.lineTo(width, edge); // Bottom-right chamfer start
    path.lineTo(width, height); // Bottom-right chamfer end
    path.lineTo(edge, height); // Bottom-left corner
    path.lineTo(0, height-edge); // Top-left chamfer end
    path.close();


    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
Widget verticalName(String vertical,double width, double height){
  return Stack(
    alignment: Alignment.center,
    children: [
      CustomPaint(
        size: Size(width, height), // Size of the octagon
        painter: OctagonPainter(edge:8, color: yellowColor),
      ),
      CustomPaint(
        size: Size(width-3, height-3), // Size of the octagon
        painter: OctagonPainter(edge: 7, color: Colors.white),
      ),
      customText(vertical, 12, FontWeight.w800, darkYellowColor, 1)
    ],
  );
}
Widget bgContainer(double width, double height){
  return Stack(
    alignment: Alignment.center,
    children: [
      CustomPaint(
        size: Size(width, height), // Size of the octagon
        painter: OctagonPainter2(edge:21, color: yellowColor),
      ),
      CustomPaint(
        size: Size(width-3, height-3), // Size of the octagon
        painter: OctagonPainter2(edge: 20, color: Colors.white),
      ),
    ],
  );
}

Widget twoMembersCard(Size size, dynamic data1, dynamic data2, String vertical, double vertWidth, double vertHeight, double leftPadding){
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: bgContainer(size.width-25, 165),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 38, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            NewTeamsCard(data: data1),
            const SizedBox(height: 5),
            NewTeamsCard(data: data2),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.only(right: (size.width/2)-leftPadding, bottom: 148),
        child: verticalName(vertical, vertWidth, vertHeight),
      )
    ],
  );
}

Widget threeMembersCard(Size size, dynamic data1, dynamic data2,dynamic data3, String vertical, double vertWidth, double vertHeight, double leftPadding){
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: bgContainer(size.width-25, 234),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            NewTeamsCard(data: data1),
            const SizedBox(height: 5),
            NewTeamsCard(data: data2),
            const SizedBox(height: 5),
            NewTeamsCard(data: data3),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.only(right: (size.width/2)-leftPadding, bottom: 217),
        child: verticalName(vertical, vertWidth, vertHeight),
      )
    ],
  );
}

Widget oneMembersCard(Size size, dynamic data1, String vertical, double vertWidth, double vertHeight, double leftPadding){
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: bgContainer(size.width-25, 91),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 36, bottom: 10),
        child: NewTeamsCard(data: data1),
      ),

      Padding(
        padding: EdgeInsets.only(right: (size.width/2)-leftPadding, bottom: 75),
        child: verticalName(vertical, vertWidth, vertHeight),
      )
    ],
  );
}

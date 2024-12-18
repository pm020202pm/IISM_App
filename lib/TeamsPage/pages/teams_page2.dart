import 'package:flutter/material.dart';
import 'package:iism/TeamsPage/pages/teams_page.dart';
import 'package:iism/TeamsPage/widgets/OfficialsCard.dart';
import '../../SchedulePage/pages/schedule_page.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';

class TeamsPageStaff extends StatefulWidget {
  const TeamsPageStaff({super.key});

  @override
  _TeamsPageStaffState createState() => _TeamsPageStaffState();
}

class _TeamsPageStaffState extends State<TeamsPageStaff> {
  int currentIndex = 0;
  double tabPadding = 10;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = currentIndex == 0 ? officials : head;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tabButton("Key Officials", currentIndex,0, (){
                          setState(() {
                            currentIndex = 0;
                          });
                        }),
                        tabButton("Core Team", currentIndex,1, (){
                          setState(() {
                            currentIndex = 1;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                if(currentIndex==0)ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => OfficialsCard(data: data[index]),
                ),
                if(currentIndex==1)ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => oneMembersCard(data[index]),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        )
        ,
      ),
    );
  }
  Widget oneMembersCard(dynamic data){
    List<String> names = splitName(data['Name']);
    String name = data['Name'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipPath(
        clipper: OctagonClipper(padding: 15),
        child: Container(
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
                    customText(name.toUpperCase(), 16, FontWeight.w700 , darkBlueColor, 1.4),
                    customText(data['Email'], 14, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.4),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

Widget tabButton(String text, int currentIndex, int ind, Function() onTap){
  double tabPadding = 10;
  return InkWell(
    onTap: (){onTap();},
    child: AnimatedContainer(
      curve: Curves.easeInOut,
      padding: EdgeInsets.all((currentIndex==ind) ? tabPadding : 8.0),
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (currentIndex==ind) ? yellowColor : Colors.grey.shade300,
      ),
      child: customText(text, (currentIndex==ind) ? 18 : 15, FontWeight.w600, (currentIndex==ind) ? Colors.white :Colors.grey.shade600, 1),
    ),
  );
}


List<Map<String, dynamic>> head = [
  {"Position": "Accommodation", "Name": "Shilankar", "Email": "slankar@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Registration Desk", "Name": "G P Bajpai", "Email": "gpbajpai@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Transport", "Name": "Jai Prakash", "Email": "jprana@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Transport", "Name": "Brij Mohan Singh", "Email": "brij@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Opening & Closing Ceremony", "Name": "Radha Saran Satsangi", "Email": "rsaran@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Food and Messing", "Name": "Rohit Pandey", "Email": "prohit@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Accounting & Stock Management", "Name": "Anuj Kumar Soni", "Email": "anujks@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Medical & First Aid", "Name": "Virendra Singh", "Email": "singhv@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "Security & Crowd Management", "Name": "Gaurav Yadav", "Email": "gyadav@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Manoj Sharma", "Email": "sharmam@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "P K Mohanty", "Email": "pradeepm@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Ankit Upadhyay", "Email": "ankitupd@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Piyush Bajaj", "Email": "piyushb@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Anand Singh", "Email": "sanand@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Anirudh Singh", "Email": "anisingh@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Ramakant", "Email": "ramakant@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Thupstan Angchuk", "Email": "thupstan@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Kamlesh Thapliyal", "Email": "kamlesht@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Deepak Singh", "Email": "vdeepak@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Kuldeep Sharma", "Email": "kuldeep@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Shubham Dwivedi", "Email": "shubhamd@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
  {"Position": "", "Name": "Raj Kumar Srivastava", "Email": "rajks@iitk.ac.in", "Instagram": "na", "Facebook": "na", "Linkedin": "na"},
];



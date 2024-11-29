import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';
class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
          child: customText("Contact Us", 28, FontWeight.w600, dark? Colors.grey.shade100:Colors.grey.shade900, 1),
        ),
        InkWell(
          onTap: (){
            makePhoneCall("+919838189697");
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              border: Border.all(color: Colors.purple.shade400),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurpleAccent, size: 23,),
                const SizedBox(width: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText("Hemant Tiwari (Organising Secretary)", 14, FontWeight.w800, darkBlueColor, 1),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: customText("+919838189697", 14, FontWeight.w800, darkBlueColor, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: (){
            makePhoneCall("05126797999");
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              border: Border.all(color: Colors.red.shade400),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: Colors.red, size: 20,),
                const SizedBox(width: 5),
                customText("Campus Security : 05126797999", 14, FontWeight.w800, darkBlueColor, 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: (){
            makePhoneCall("05126797769");
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.health_and_safety_outlined, color: Colors.green, size: 23,),
                const SizedBox(width: 3),
                customText("Health Center : 05126797769", 14, FontWeight.w800, darkBlueColor, 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.email_rounded, color: Colors.indigo, size: 23,),
              const SizedBox(width: 3),
              SelectableText("Email : ocs_iism24@iitk.ac.in", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: darkBlueColor)),
            ],
          ),
        ),
      ],
    );
  }


}



Future<void> makePhoneCall(String phoneNumber) async {
  final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    errorSnackMsg('Could not call $phoneNumber');
    throw 'Could not launch $callUri';
  }
}

Future<void> makeEmail(String email) async {
  final Uri callUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    errorSnackMsg('Could not call $email');
    throw 'Could not launch $callUri';
  }
}

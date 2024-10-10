import 'package:flutter/material.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';

class Sponsors extends StatelessWidget {
  const Sponsors({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0, bottom: 8.0),
          child: customText("Sponsors", 28, FontWeight.w600, dark? Colors.grey.shade100:Colors.grey.shade900, 1),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: dark? Colors.grey.shade400 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/images/ceat.png', width: 150,height: 50, fit:BoxFit.cover,),
                  Image.asset('assets/images/cred.png', width: 170, height: 80, fit:BoxFit.cover,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/images/tata.png', width: 110,height: 50, fit:BoxFit.cover,),
                  Image.asset('assets/images/vivo.png', width: 160, height: 80, fit:BoxFit.cover,),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SoilTest extends StatefulWidget {
  const SoilTest({super.key});

  @override
  State<SoilTest> createState() => _SoilTestState();
}

class _SoilTestState extends State<SoilTest> {

  bool isYes = true;

  void message(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        behavior: SnackBarBehavior.floating,
        content: Text('Updated Successfully!'),
        showCloseIcon: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Spacer(flex: 2,),
            Container(
              child: (isYes) ? Column(
                children: [
                  Text(AppLocalizations.of(context)!.wantSoilTest, style: TextStyle(fontSize: 30),),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        isYes = false;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.yesIWant,
                      style: TextStyle(fontSize: 18)
                    )
                  ),
                  TextButton(onPressed: (){}, child: Text(AppLocalizations.of(context)!.noDoubtClarification, style: TextStyle(fontSize: 18))),
                ],
              ) : Column(
                children: [
                  Text(AppLocalizations.of(context)!.howManyAcres, style: TextStyle(fontSize: 30),),
                  TextButton(onPressed: (){message(); setState(() {isYes = true;});}, child: Text('Less than 1 Acre', style: TextStyle(fontSize: 20),)),
                  TextButton(onPressed: (){message(); setState(() {isYes = true;});}, child: Text('1 - 5 Acre', style: TextStyle(fontSize: 20),)),
                  TextButton(onPressed: (){message(); setState(() {isYes = true;});}, child: Text('6 - 10 Acres', style: TextStyle(fontSize: 20),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){}, child: Text('Others : ', style: TextStyle(fontSize: 20),)),
                      SizedBox(width: 70, child: TextField(keyboardType: TextInputType.number,),)
                    ],
                  )
                ],
              ),
            ),
            Spacer(flex: 1,),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      style: TextStyle(fontSize: 16),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enterYourProblem, border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){if(!isYes) message(); setState(() {isYes = true;});},
                  style: ElevatedButton.styleFrom(shape: CircleBorder()),
                  child: Icon(Icons.arrow_upward),
                )
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
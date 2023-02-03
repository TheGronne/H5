import 'dart:html';
import 'package:afslutnings_opgave/colour_page.dart';
import 'package:afslutnings_opgave/name_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PageOne()));
}

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  String nameMessage = "Get ones name and colour";
  String choiceMessage = "Here comes the name";
  String? chosenRelation = "Relation";
  Color chosenColour = Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SlutOpgaveHentNavnOgFarve'),
          backgroundColor: Color.fromARGB(255, 100, 0, 100),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
              Container(
                  child: Text(
                nameMessage,
                style: TextStyle(
                    color: Color.fromARGB(100, 100, 100, 100), fontSize: 20),
              )),
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        awaitReturnValueFromNamePage(context);
                      },
                      child: Text('Get Ones Name'))),
            ]),
            Column(
              children: [
                Container(
                    child: Text(
                  choiceMessage,
                  style: TextStyle(
                      color: Color.fromARGB(100, 100, 100, 100),
                      fontSize: 20,
                      backgroundColor: chosenColour),
                )),
                Container(
                    child: ElevatedButton(
                        onPressed: () {
                          awaitReturnValueFromColourPage(context);
                        },
                        child: Text('Get Ones Colour'))),
              ],
            )
          ],
        )));
  }

  @override
  void awaitReturnValueFromNamePage(BuildContext context) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NamePage()));
    setState(() {
      if (result.chosen != "" && result.name != "") {
        chosenRelation = result.chosen;
        choiceMessage = "${result.chosen}'s name: ${result.name}";
      }
    });
  }

  @override
  void awaitReturnValueFromColourPage(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ColourPage(chosenRelation)));
    setState(() {
      chosenColour = result;
    });
  }
}

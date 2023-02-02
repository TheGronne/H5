import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:afslutnings_opgave/main.dart';
import 'package:flutter/material.dart';

class ColourPage extends StatefulWidget {
  final String? chosenRelation;
  const ColourPage(this.chosenRelation, {super.key});

  @override
  State<ColourPage> createState() => _ColourPageState();
}

const List<String> codes = <String>[
  '00',
  '10',
  '20',
  '30',
  '40',
  '50',
  '60',
  '70',
  '80',
  '90',
  'AD',
  'B0',
  'C0',
  'D0',
  'E0',
  'F0',
  'FF'
];

class _ColourPageState extends State<ColourPage> {
  String? alpha = "FF";
  String? red = "FF";
  String? green = "FF";
  String? blue = "FF";
  Color? chosenColour = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Colour Page',
        home: Scaffold(
            appBar: AppBar(
              title: Text('SlutOpgaveHentNavnOgFarve'),
              backgroundColor: Color.fromARGB(255, 0, 100, 100),
            ),
            body: Column(
              children: [
                Center(
                    child: Column(
                  children: [
                    Text("${widget.chosenRelation}'s Colour"),
                  ],
                )),
                Container(
                  color: chosenColour,
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                        value: alpha,
                        items:
                            codes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            alpha = value;
                            chosenColour = hexToColor(alpha, red, green, blue);
                          });
                        }),
                    DropdownButton<String>(
                        value: red,
                        items:
                            codes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            red = value;
                            chosenColour = hexToColor(alpha, red, green, blue);
                          });
                        }),
                    DropdownButton<String>(
                        value: green,
                        items:
                            codes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            green = value;
                            chosenColour = hexToColor(alpha, red, green, blue);
                          });
                        }),
                    DropdownButton<String>(
                        value: blue,
                        items:
                            codes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            blue = value;
                            chosenColour = hexToColor(alpha, red, green, blue);
                          });
                        })
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          awaitReturnValueFromPageOne(context);
                        },
                        child: Text('SEND COLOUR'))
                  ],
                )
              ],
            )));
  }

  @override
  void awaitReturnValueFromPageOne(BuildContext context) async {
    Navigator.pop(context, chosenColour);
  }

  @override
  Color? hexToColor(String? alpha, String? red, String? green, String? blue) {
    return Color(int.parse("0x${alpha}${red}${green}${blue}"));
  }
}

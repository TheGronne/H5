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
  Color? chosenColour = Color(0xFFFFFFFF);
  List<String?> argb = <String?>["FF", "FF", "FF", "FF"];

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: hexDropDowns()),
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
  List<Widget> hexDropDowns() {
    List<String?> choices = <String?>["Alpha", "Red", "Green", "Blue"];
    List<Widget> widgets = <Widget>[];

    for (int i = 0; i < choices.length; i++) {
      widgets.add(Text("${choices[i]}:"));
      widgets.add(DropdownButton<String>(
          value: argb[i],
          items: codes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              argb[i] = value;
              chosenColour = hexToColor(argb[0], argb[1], argb[2], argb[3]);
            });
          }));
    }

    return widgets;
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

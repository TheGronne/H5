import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:afslutnings_opgave/main.dart';
import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

enum Choices { Mother, Father, Cat, Dog }

class UserChoice {
  UserChoice(String? _chosen, String? _name) {
    chosen = _chosen;
    name = _name;
  }
  String? chosen = "";
  String? name = "";
}

class _NamePageState extends State<NamePage> {
  TextEditingController textFieldController = TextEditingController();
  String? chosen = "Relation";

  List<String?> genders = Choices.values.map((e) => e.name).toList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SlutOpgaveHentNavnOgFarve'),
          backgroundColor: Color.fromARGB(255, 100, 100, 0),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Write name of your..."),
            SizedBox(
              width: 200,
              child: Column(
                children: listToRadio(genders),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: Text("$chosen's name: "),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: textFieldController,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  awaitReturnValueFromPageOne(context);
                },
                child: Text('SEND'))
          ],
        )),
      ),
    );
  }

  @override
  void awaitReturnValueFromPageOne(BuildContext context) async {
    Navigator.pop(context, UserChoice(chosen, textFieldController.text));
  }

  List<RadioListTile> listToRadio<T>(List<T> values) {
    List<RadioListTile> buttons = <RadioListTile>[];
    for (var v in values) {
      buttons.add(RadioListTile(
          title: Text(v.toString()),
          value: v.toString(),
          groupValue: chosen,
          onChanged: (value) {
            setState(() {
              chosen = value;
            });
          }));
    }

    return buttons;
  }
}

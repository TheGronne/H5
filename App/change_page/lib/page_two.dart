import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:change_page/main.dart';
import 'package:flutter/material.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two Pages',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Page Two'),
          ),
          body: Column(
            children: [
              TextField(
                controller: textFieldController,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    awaitReturnValueFromPageOne(context);
                  },
                  child: Text('Go back'))
            ],
          )),
    );
  }

  @override
  void awaitReturnValueFromPageOne(BuildContext context) async {
    String textToSendBack = textFieldController.text;
    Navigator.pop(context, textToSendBack);
  }
}

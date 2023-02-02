import 'dart:html';
import 'package:change_page/page_two.dart';
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
  String messageFromPageTwo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Page One'),
        ),
        body: Column(
          children: [
            Text(messageFromPageTwo),
            ElevatedButton(
                onPressed: () {
                  awaitReturnValueFromPageTwo(context);
                },
                child: Text('Go to page two'))
          ],
        ));
  }

  @override
  void awaitReturnValueFromPageTwo(BuildContext context) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageTwo()));
    setState(() {
      messageFromPageTwo = result;
    });
  }
}

/*
  Zaia Nicola 5°CIA
  14/02/2022
*/
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as htmlParser; // to print html chars

class Button extends StatelessWidget {
  final Function() selectHandler;
  final String buttonText;
  final Color color;

  Button(
      {required this.selectHandler,
      required this.buttonText,
      this.color = Colors.greenAccent});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75, //double.infinity,
        child: RaisedButton(
          color: this.color,
          // textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          child: Text(
              htmlParser.DocumentFragment.html(buttonText).text.toString()),
          onPressed: selectHandler,
        ));
  }
}

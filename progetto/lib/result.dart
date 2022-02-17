/*
  Zaia Nicola 5°CIA
  14/02/2022
*/

import 'package:flutter/material.dart';

class ResultsRoute extends StatelessWidget {
  final int rightAnswers;

  ResultsRoute({required int this.rightAnswers});

  @override
  Widget build(BuildContext context) {
    String points = this.rightAnswers.toString() + " / 10";

    return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  points,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Finished with: " +
                      (rightAnswers / 10 * 100).toString() +
                      "%",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

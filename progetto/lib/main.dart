// This app gets data from Firebase RealTime database through http requests
// https://pub.dev/packages/http

/*
  Zaia Nicola 5°CIA
  14/02/2022
*/
import 'dart:convert';

import 'package:firstassignment/models/question.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './textdisplay.dart';
import './button.dart';

import 'result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Zaia Nicola 5°CIA - Quiz App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample url:
  final baseurl = "https://opentdb.com/api.php?amount=10"; //max 10

  List<Question>? _questions = null; // questions data structure
  List<String>? _answers = null; // answers list
  List<int> _answered = [];
  var _index = 0;
  int punteggio = 0;

  // Go to next question:
  void next() {
    if (_questions == null || _questions!.length == 0) return;
    setState(() {
      if (_index < _questions!.length - 1)
        _index++;
      else
        _index = 0;
      // update answers:
      _answers = List.from(_questions![_index].incorrect);
      _answers!.add(_questions![_index].correct);
      _answers!.shuffle();
    });
  }

  // Get data
  void doGet() {
    http.get(Uri.parse(baseurl)).then((response) {
      var jsondata = json.decode(response.body);
      var questions = jsondata['results'];

      // create data structure with questions
      setState(() {
        _questions =
            questions.map<Question>((val) => Question.fromJson(val)).toList();
        // initialize answer list:
        _answers = List.from(_questions![_index].incorrect);
        _answers!.add(_questions![_index].correct);
        _answers!.shuffle();
      });

      // debug
      print("First question: " + questions[0]['question']);
      print("First question: " + questions[0]['correct_answer']);
      print("category: " + questions[0]['category']);
    });
  }

  // Post data to Firebase
  void doPost(String postUrl) {
    http
        .post(Uri.parse(postUrl),
            body: json.encode({
              'name': "Pluto",
              'email': "pluto@whitehouse.gov",
              'zipcode': 12364,
              'id': 0
            }))
        .then((response) {
      var jsondata = json.decode(response.body);

      // debug
      print("Server response: " + response.statusCode.toString());
    });
  }

  // Check if the answer is correct and display an AlertDialog:
  void _checkAnswer(String ans) {
    String msg =
        "Sorry, but the correct answer was " + _questions![_index].correct;
    if (ans == _questions![_index].correct) {
      msg = "Congratulation! The correct answer was " +
          _questions![_index].correct;
      if (!_answered.contains(_index)) {
        punteggio++;
      }
    }
    if (!_answered.contains(_index)) {
      _answered.add(_index);
    } else {
      msg = "Already answered!";
    }
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Result'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  autofocus: true,
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    next(); //ci si sposta nella pagina successiva
                    if (_index == 9) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResultsRoute(
                            rightAnswers: punteggio,
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ));
  }

  // Return a list of buttons with the answers to put in the screen:
  List<Widget> _buildAnswerButtons(List<String> ans) {
    return ans
        .map<Button>(
            (e) => Button(selectHandler: () => _checkAnswer(e), buttonText: e))
        .toList();
  }

  void initState() {
    doGet();
  }

  void resetQuiz() {
    setState(() {
      _questions = null; // questions data structure
      _answers = null; // answers list
      _answered = [];
      _index = 0;
      punteggio = 0;
    });
    doGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: TextDisplay(
              (_questions != null && _questions![0] != null)
                  ? _questions![_index].question
                  : 'none',
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_answers != null && _buildAnswerButtons(_answers!) != null)
                  ..._buildAnswerButtons(_answers!)
                else
                  const CircularProgressIndicator(), //Text('Load Quiz!'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Button(
                    selectHandler: next,
                    buttonText: 'next',
                    color: Colors.blueAccent),
                Button(
                    selectHandler: resetQuiz,
                    buttonText: 'reload',
                    color: Colors.blueAccent),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Text(
                    "Question " + (_index + 1).toString(), //funzione aggiuntiva
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Score: " + punteggio.toString(), //funzione aggiuntiva
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

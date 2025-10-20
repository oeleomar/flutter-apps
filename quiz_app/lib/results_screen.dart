import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.choseAnswers});

  final List<String> choseAnswers;

  List<Map<String, Object>> getSummarData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < choseAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answers': questions[i].answers[0],
        'user_answer': choseAnswers[i],
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Você respondeu X de Y perguntas corretamente!'),
            SizedBox(height: 30),
            Text('Lista de perguntas e respostas:'),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {},
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

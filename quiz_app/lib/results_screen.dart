import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_summary/questions_summary.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.choseAnswers,
    required this.onRestart,
  });

  final List<String> choseAnswers;
  final void Function() onRestart;

  List<Map<String, Object>> getSummarData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < choseAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': choseAnswers[i],
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final sumarryData = getSummarData();
    final int numTotalQuestions = questions.length;
    final int numCorrectQuestions = sumarryData.where((data) {
      return data['correct_answer'] == data['user_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você respondeu $numCorrectQuestions de $numTotalQuestions perguntas corretamente!',
              style: GoogleFonts.lato(
                color: Color.fromARGB(185, 255, 255, 255),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            QuestionsSummary(summaryData: sumarryData),
            const SizedBox(height: 30),

            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  onTap() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Question'),
          SizedBox(
            height: 30,
          ),
          AnswerButton(
            text: 'Resposta 1',
            onTap: onTap,
          ),
          AnswerButton(
            text: 'Resposta 2',
            onTap: onTap,
          ),
          AnswerButton(
            text: 'Resposta 3',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

import 'package:dice_app/dice_roller.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.gradient, {super.key});
  const GradientContainer.purple({super.key})
    : gradient = const [
        Color.fromARGB(255, 66, 165, 245),
        Color.fromARGB(255, 21, 63, 114),
        Color.fromARGB(255, 1, 25, 46),
      ];

  final List<Color> gradient;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: DiceRoller()),
    );
  }
}

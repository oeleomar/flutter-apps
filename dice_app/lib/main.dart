import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF42A5F5), // Light Blue
                Color(0xFF478DE0), // Medium Blue
                Color(0xFF1E88E5), // Darker Blue
              ],
            ),
          ),
          child: Center(
            child: Text('Hello, Flutter!'),
          ),
        ),
      ),
    ),
  );
}

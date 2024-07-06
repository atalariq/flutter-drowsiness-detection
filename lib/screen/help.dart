import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This is the Help page.',
              style: TextStyle(fontSize: 24),
            ),
            FAQ(question: "Question 1", answer: "data"),
            FAQ(question: "Question 2", answer: "data"),
            FAQ(question: "Question 3", answer: "data"),
            FAQ(question: "Question 4", answer: "data"),
          ],
        ),
      ),
    );
  }
}

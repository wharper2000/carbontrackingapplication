import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/widgets/custom_form.dart';
import 'package:flutter/material.dart';

class FormQuestionsScreen extends StatefulWidget {
  const FormQuestionsScreen({super.key});

  @override
  State<FormQuestionsScreen> createState() => _FormQuestionsScreenState();
}

class _FormQuestionsScreenState extends State<FormQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Yearly Estimation Form',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: MyCustomForm()),
          ],
        ),
      ),
      );
  }
}
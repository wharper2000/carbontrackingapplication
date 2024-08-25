import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/screens/app_bar_screen.dart';
import 'package:carbon_tracker/screens/form_questions_screen.dart';
import 'package:carbon_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yearly Estimation',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This form will ask you varying questions related to your carbon emissions & will build up a yearly average. This average will change once you start tracking your everyday carbon emissions.',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormQuestionsScreen(),
                  ),
                );
              },
              style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppColours.primaryAccent),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                elevation: WidgetStatePropertyAll(8),
              ),
              child: const Text('Continue With Form'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyNavigationBar(),
                    ),
                  );
                },
                child: const Text('Cancel'),)
          ],
        ),
      ),
    );
  }
}

import 'package:carbon_tracker/assets/colours.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColours.primaryAccent,
      shadowColor: Colors.black,
      foregroundColor: Colors.white,
    );
  }
}

import 'package:carbon_tracker/assets/colours.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final Color foregroundColor;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColours.primaryAccent,
    this.shadowColor = Colors.black,
    this.foregroundColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shadowColor: shadowColor,
        foregroundColor: foregroundColor,
        elevation: 8,
      ),
      child: Text(text),
    );
  }
}

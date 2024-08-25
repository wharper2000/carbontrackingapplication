import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/screens/app_bar_screen.dart';
import 'package:carbon_tracker/screens/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Carbon Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColours.primaryAccent),
          useMaterial3: true,
          primaryTextTheme: TextTheme(
            headlineLarge: GoogleFonts.roboto(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            headlineMedium: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            headlineSmall: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bodyLarge: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bodyMedium: GoogleFonts.nunito(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.normal,
              color: AppColours.accentDark,
            ),
            bodySmall: GoogleFonts.roboto(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.normal,
              color: AppColours.accentVeryDark,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                  color: AppColours.accentDark,
                  width: 2.0), // Change border color
            ),
            // Add more InputDecoration properties as needed
          ),
        ),
        home: MyNavigationBar(),
      ),
    );
  }
}

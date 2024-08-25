import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:carbon_tracker/screens/new_emission_screen.dart';
import 'package:carbon_tracker/widgets/recent_emissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackCarbonScreen extends ConsumerWidget {
  TrackCarbonScreen({
    required this.getDateKey,
    required this.updatePage,
    required this.getCommonEmissions,
    super.key
  });

  final String Function(DateTime) getDateKey;
  final Function updatePage;
  final List<double> getCommonEmissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalTrackedEmissions = getCommonEmissions[0];
    final totalEstimatedEmissions = getCommonEmissions[3];
  
    return Scaffold(
      key: const Key('tracking_screen'),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColours.accentDark,
            height: 2.0,
          ),
        ),
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColours.bgOff,
        shadowColor: AppColours.accentDark,
        title: Text(
          'Track Your Carbon',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: ListView(
       padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        children: [
          Text(
            'Your personal carbon footprint today is:',
            style: Theme.of(context).primaryTextTheme.bodySmall,
          ),
          if (totalTrackedEmissions - totalEstimatedEmissions < 0)
                  Text(
                    '${totalTrackedEmissions.toStringAsFixed(3)} kg C02',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800),
                  ),
                if (totalTrackedEmissions - totalEstimatedEmissions > 0)
                  Text(
                    '${totalTrackedEmissions.toStringAsFixed(3)} kg C02',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800),
                  ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewEmissionScreen(updatePage: updatePage,),
                  ),
                );
              },
              style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppColours.primaryAccent),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                elevation: WidgetStatePropertyAll(8),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              child: const Text('Add Carbon Emission'),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          RecentEmissions(
            getDateKey: getDateKey,
          ),
        ],
      ),
    );
  }
}

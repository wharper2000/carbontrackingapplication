import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:carbon_tracker/screens/more_information_screen.dart';
import 'package:carbon_tracker/screens/new_emission_screen.dart';
import 'package:carbon_tracker/widgets/line_chart.dart';
import 'package:carbon_tracker/widgets/recent_emissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    required this.getDateKey,
    required this.updatePage,
    required this.getCommonEmissions,
    super.key,
  });

  final String Function(DateTime) getDateKey;
  final Function updatePage;
  final List<double> getCommonEmissions;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final totalTrackedEmissions = widget.getCommonEmissions[0];
    final totalEstimatedEmissions = widget.getCommonEmissions[3];
    final totalYearEstimated = widget.getCommonEmissions[1];
    final emissionItems = ref.watch(emissionItemProvider);

    return Scaffold(
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
          'Your Carbon Footprint',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
        actions: [
          IconButton(
            icon: const Icon(
                Icons.info),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MoreInformationScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: AppColours.bg,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Daily Average:',
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                        Text(
                          '${totalEstimatedEmissions.toStringAsFixed(3)} kg C02',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColours.accentVeryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Yearly Estimation:',
                          style: Theme.of(context).primaryTextTheme.bodySmall,
                        ),
                        Text(
                          '${totalYearEstimated.toStringAsFixed(3)} tC02',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColours.accentVeryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              EmissionsChart(
                key: const Key('emissions_chart'),
                emissionItems: emissionItems,
                totalEstimatedEmissions: totalEstimatedEmissions,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: Key('primary_home_button'),
                      onPressed: () {
                        widget.updatePage(1);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColours.primaryAccent),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        elevation: WidgetStatePropertyAll(8),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Track Your Emissions Today',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      key: Key('secondary_home_button'),
                      onPressed: () {
                        widget.updatePage(2);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(AppColours.bg),
                        foregroundColor:
                            const WidgetStatePropertyAll(AppColours.accentDark),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                            color: AppColours
                                .accentDark, // The color of the border
                            width: 2.0, // The width of the border
                          ),
                        )),
                        elevation: const WidgetStatePropertyAll(8),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                      child: const Text(
                        'View Reduction Methods',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ), // Add some spacing before the list
              RecentEmissions(getDateKey: widget.getDateKey),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

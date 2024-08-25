import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:carbon_tracker/widgets/category_cards.dart';
import 'package:carbon_tracker/widgets/pie_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ReduceEmissionsScreen extends ConsumerStatefulWidget {
  const ReduceEmissionsScreen({
    required this.getCommonEmissions,
    super.key,
  });

  final List<double> getCommonEmissions;

  @override
  ConsumerState<ReduceEmissionsScreen> createState() =>
      _ReduceEmissionsScreenState();
}

class _ReduceEmissionsScreenState extends ConsumerState<ReduceEmissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final totalDailyEmissions = widget.getCommonEmissions[2];
    final emissionItems = ref.watch(emissionItemProvider);

    return Scaffold(
      key: const Key('reduce_screen'),
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
          'Reduce Your Emissions',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your total tracked carbon emissions so far this year are:',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
              Text(
                '${totalDailyEmissions.toStringAsFixed(3)} kg C02',
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColours.accentVeryDark),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'All your tracked carbon emissions split by category:',
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              AspectRatio(
                aspectRatio: 1.5,
                child: MyPieChart(
                  emissionItems: emissionItems,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Card(
            color: AppColours.bg,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: AppColours.accentVeryDark, width: 2.0),
              borderRadius:
                  BorderRadius.circular(20.0), // Optional: Adds rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Categories To Improve',
                style: Theme.of(context).primaryTextTheme.headlineMedium,
              ),
            ),
          ),
          
          //INSERT CATEGORY CARDS WIDGET
          CategoryCards(
            getCommonEmissions: widget.getCommonEmissions,
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPieChart extends ConsumerWidget {
  final List<EmissionItem> emissionItems; // Assume this is passed to the widget
  final GlobalKey? pieChartKey; // Create a key for the PieChart

  MyPieChart({required this.emissionItems, Key? key, this.pieChartKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emissionNotifier = ref.watch(emissionItemProvider.notifier);
    final todayEmissions = ref
        .watch(emissionItemProvider.notifier)
        .getTodayEmissionItems(emissionItems);
    final categoryEmissions =
        emissionNotifier.calculateCategoryEmissions(emissionItems);

    // Prepare data for pie chart
    var pieChartData = preparePieChartData(categoryEmissions);

    return Row(
      children: [
        Expanded(
          child: PieChart(
            key: pieChartKey,
            PieChartData(
              sections: pieChartData.sections,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 5,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: categoryEmissions.keys.map((category) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    color: getColorForCategory(category),
                  ),
                  SizedBox(width: 6),
                  Text(
                    EmissionCategoriesDisplayName[category] ??
                        category.toString().split('.').last,
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  PieChartData preparePieChartData(
      Map<EmissionCategories, double> categoryEmissions) {
    List<PieChartSectionData> pieChartData = [];

    categoryEmissions.forEach((category, emissionValue) {
      final section = PieChartSectionData(
        value: emissionValue,
        title: /* emissionValue.toStringAsFixed(3) */ '', 
        color: getColorForCategory(category),
        radius: 110,
        titlePositionPercentageOffset: 0.65,
        titleStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        /* badgeWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            Text(
              EmissionCategoriesDisplayName[category] ??
                  category.toString().split('.').last,
              style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            )
          ],
        ), */
      );
      pieChartData.add(section);
    });

    return PieChartData(
      sections: pieChartData,
      borderData: FlBorderData(show: false),
      centerSpaceRadius: 40,
      sectionsSpace: 0,
    );
  }

  Color getColorForCategory(EmissionCategories category) {
    // Implement a method to return a color based on the category
    // Example:
    switch (category) {
      case EmissionCategories.bus:
        return Colors.brown;
      case EmissionCategories.flight:
        return Colors.red;
      case EmissionCategories.food:
        return Colors.green;
      case EmissionCategories.fuel:
        return Colors.black;
      case EmissionCategories.household:
        return Colors.orange;
      case EmissionCategories.passengerVehicle:
        return Colors.blue;
      case EmissionCategories.train:
        return Colors.pink;
      // Add more cases for other categories
      default:
        return Colors.grey;
    }
  }
}

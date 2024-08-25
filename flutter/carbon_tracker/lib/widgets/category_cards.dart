import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/assets/emission_values.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CategoryCards extends ConsumerWidget {
  const CategoryCards({
    required this.getCommonEmissions,
    super.key,
  });
  final List<double> getCommonEmissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: categories(getCommonEmissions, ref, context),
    );
  }

  List<Widget> categories(getCommonEmissions, ref, context) {
    final emissionItems = ref.watch(emissionItemProvider);
    final emissionNotifier = ref.watch(emissionItemProvider.notifier);
    final categoryEmissions =
        emissionNotifier.calculateCombinedCategoryEmissions(emissionItems);
    // Convert entries to a list for sorting
    List<MapEntry<EmissionCategories, double>> sortedEntries =
        categoryEmissions.entries.toList();
    // Sort the entries by emission values in descending order
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    // Create a list of Card widgets based on sorted categories
    int indexCustom = 0;
    List<Widget> categoryCards = sortedEntries.map((entry) {
      indexCustom += 1;
      // Calculate interpolation value (from 0.0 to 1.0) based on index
      double interpolationValue = (1 / 4) * indexCustom < 1
          ? (1 / 4) * indexCustom
          : 1; // 0.0 to 1.0 range
      // Interpolate between Colors.green and appBgColor
      Color interpolatedColor =
          Color.lerp(Colors.red.shade100, AppColours.bg, interpolationValue)!;

      return Card(
        color: interpolatedColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColours.accentVeryDark, width: 2.0),
          borderRadius:
              BorderRadius.circular(20.0), // Optional: Adds rounded corners
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${EmissionCategoriesDisplayName[entry.key]}: ${entry.value.toStringAsFixed(3)} kg CO2 Emitted',
                style: Theme.of(context).primaryTextTheme.headlineSmall,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(CategoryDescriptions[entry.key] ?? 'Unknown'),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(
                      width: 2, color: AppColours.accentVeryDark),
                ),
                onPressed: () => _launchURL(
                  CategoryUrls[entry.key],
                ),
                child: Text(
                  'Read More',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
              ),
            ],
          ), // Display category name and emission value
        ),
      );
    }).toList();

    return categoryCards;
  }
}

Future _launchURL(targetUrl) async {
  final Uri url = Uri.parse(targetUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

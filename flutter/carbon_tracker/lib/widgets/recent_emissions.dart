import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/assets/emission_values.dart';
import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentEmissions extends ConsumerStatefulWidget {
  final Function(DateTime) getDateKey;

  const RecentEmissions({
    super.key,
    required this.getDateKey,
  });

  @override
  ConsumerState<RecentEmissions> createState() => _RecentEmissionsState();
}

class _RecentEmissionsState extends ConsumerState<RecentEmissions> {

  @override
  void initState() {
    super.initState();
    widget.getDateKey;
    // Call this method after modifying emissionItems
    _groupItemsByDate(ref);
  }

  List<dynamic> _groupedEmissionItems = [];
  Map<EmissionItem, int> _originalIndices = {};

  void _groupItemsByDate(WidgetRef ref) {
    final emissionItems = ref.read(emissionItemProvider);

    final Map<String, List<EmissionItem>> groupedItems = {};
    _originalIndices.clear();

    for (var i = 0; i < emissionItems.length; i++) {
      final item = emissionItems[i];
      final dateKey = widget.getDateKey(item.timestamp);
      if (!groupedItems.containsKey(dateKey)) {
        groupedItems[dateKey] = [];
      }
      groupedItems[dateKey]!.add(item);
      _originalIndices[item] = i;
    }

    _groupedEmissionItems.clear();

    groupedItems.forEach((key, items) {
      _groupedEmissionItems.add(key);
      _groupedEmissionItems.addAll(items);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Tracked Carbon',
          style: Theme.of(context).primaryTextTheme.headlineMedium,
        ),
        const SizedBox(
          height: 8,
        ),
        Consumer(
          builder: (context, ref, child) {
            // Group items by date whenever the provider updates
            _groupItemsByDate(ref);
            return ListView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
              shrinkWrap:
                  true, // Make the ListView take only the required height
              itemCount: _groupedEmissionItems.length,
              itemBuilder: (context, index) {
                final item = _groupedEmissionItems[index];
                if (item is String) {
                  // This is a header
                  return ListTile(
                    contentPadding: const EdgeInsets.only(top: 0),
                    title: Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: AppColours.accentDark,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            item,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headlineSmall,
                          ),
                          Expanded(
                            child: Text(
                              'Carbon Emissions (CO2/yr)',
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (item is EmissionItem) {
                  // This is an EmissionItem
                  return Dismissible(
                    key: Key(
                        item.timestamp.toString()), // Unique key for each item
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      final originalIndex = _originalIndices[item];
                      if (originalIndex != null) {
                        ref
                            .read(emissionItemProvider.notifier)
                            .removeEmissionItem(originalIndex);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${allEmissionNames[item.type]} removed',
                            ),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                ref
                                    .read(emissionItemProvider.notifier)
                                    .addEmissionItemAt(originalIndex, item);
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      dense: true,
                      title: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    EmissionCategoriesIcon[item.category],
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ), // Adjust the width to the desired space
                                ],
                              ),
                            ),
                            TextSpan(
                              text: allEmissionNames[item.type]!,
                              style:
                                  Theme.of(context).primaryTextTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        '${item.timestamp.hour}:${item.timestamp.minute}',
                      ),
                      trailing: Text(
                        '${item.emissionValue.toStringAsFixed(3)} kg',
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                      contentPadding: EdgeInsets.zero, // Ensure no padding
                    ),
                  );
                } else {
                  return const SizedBox
                      .shrink(); // In case of any unexpected type
                }
              },
            );
          },
        ),
      ],
    );
  }
}

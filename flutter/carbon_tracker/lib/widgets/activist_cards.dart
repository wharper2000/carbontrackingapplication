import 'package:carbon_tracker/assets/activist_activites.dart';
import 'package:carbon_tracker/assets/colours.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivistCards extends StatelessWidget {
  const ActivistCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: activistCards(context),
    );
  }
}

List<Widget> activistCards(context) {
  // Create a list of Card widgets based on sorted categories
  List<ActivistActivites> items = ActivistActivites.values.toList();
  List<Card> activistCards = items.map((entry) {
    return Card(
      color: AppColours.bg,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColours.accentVeryDark, width: 2.0),
        borderRadius:
            BorderRadius.circular(20.0), // Optional: Adds rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ActivistActivitesNames[entry]!,
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              ActivistActivitesDescriptions[entry]!,
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                    width: 2, color: AppColours.accentVeryDark),
              ),
              onPressed: () async {
                String targetUrl = ActivistActivitesUrl[entry]!;
                await _launchURL(targetUrl);
              },
              child: Text(
                'Read More',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();

  return activistCards;
}

Future _launchURL(targetUrl) async {
  final Uri url = Uri.parse(targetUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/widgets/activist_cards.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivismScreen extends StatefulWidget {
  const ActivismScreen({super.key});

  @override
  State<ActivismScreen> createState() => _ActivismScreenState();
}

class _ActivismScreenState extends State<ActivismScreen> {
  @override
  Widget build(BuildContext context) {
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
          'What Can You Do?',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        children: [
          Text(
            'According to the Intergovernmental Panel on Climate Change (IPCC), around 70% of carbon dioxide emissions stem from just 100 companies worldwide.',
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
          Text(
            'This shows that individual responsibility is irrelevant and distracting from requesting true change.\nThe government should be responsible to regulate these companies. If you want to make a real change here are some courses of action:',
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
          const SizedBox(
            height: 16,
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
                'Take Action',
                style: Theme.of(context).primaryTextTheme.headlineMedium,
              ),
            ),
          ),
          ActivistCards(),
          const SizedBox(
            height: 24,
          ),
          Wrap(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(
                      width: 2, color: AppColours.accentVeryDark),
                ),
                onPressed: () => _launchURL(
                    'https://cz.boell.org/en/2023/07/26/individual-carbon-footprint-how-much-does-it-actually-matter'),
                child: Text(
                  'Learn More',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

Future _launchURL(targetUrl) async {
  final Uri url = Uri.parse(targetUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

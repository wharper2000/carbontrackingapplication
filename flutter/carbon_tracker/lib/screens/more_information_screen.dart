import 'package:carbon_tracker/assets/colours.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInformationScreen extends StatelessWidget {
  const MoreInformationScreen({super.key});

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
          'More Features',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code Base',
              style: Theme.of(context).primaryTextTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Click below to view the codebase for this application, feel free to use any part of this code to improve upon.',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                    width: 2, color: AppColours.accentVeryDark),
              ),
              onPressed: () => _launchURL(
                  'https://github.com/wharper2000/carbontrackingapplication'),
              child: Text(
                'View Codebase',
                style: Theme.of(context).primaryTextTheme.bodySmall,
              ),
            ),
          ],
        ),
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


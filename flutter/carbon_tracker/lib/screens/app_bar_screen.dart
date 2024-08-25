import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:carbon_tracker/screens/activism_screen.dart';
import 'package:carbon_tracker/screens/home_screen.dart';
import 'package:carbon_tracker/screens/new_emission_screen.dart';
import 'package:carbon_tracker/screens/reduce_emissions_screen.dart';
import 'package:carbon_tracker/screens/track_emissions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class MyNavigationBar extends ConsumerStatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

String getDateKey(DateTime timestamp) {
  final now = DateTime.now();
  if (timestamp.year == now.year &&
      timestamp.month == now.month &&
      timestamp.day == now.day) {
    return 'Today';
  } else if (timestamp.year == now.year &&
      timestamp.month == now.month &&
      timestamp.day == now.day - 1) {
    return 'Yesterday';
  } else {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class _MyNavigationBarState extends ConsumerState<MyNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Callback function to update selectedIndex from child pages
  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> getCommonEmissions() {
      final userInfo = ref.watch(userInfoProvider);
      final emissionItems = ref.watch(emissionItemProvider);
      final emissionNotifier = ref.watch(emissionItemProvider.notifier);
      final averageEmissions = userInfo.totalEmissions / 365 * 1000;
      final totalEmissionsToday =
          ref.watch(emissionItemProvider.notifier).getTodayEmissions();

      // Sort emissionItems based on timestamp (newest first)
      emissionItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Calculate total emissions
      double totalTrackedEmissions = 0.0;
      double totalDailyEmissions = 0.0;
      Set<String> trackedDays = {}; // To keep track of unique days

      for (var item in emissionItems) {
        trackedDays.add(emissionNotifier.getDateKey(item.timestamp));
        var today = emissionNotifier.getDateKey(item.timestamp);
        if (today == 'Today') {
          totalTrackedEmissions += item.emissionValue;
        }
        totalDailyEmissions += item.emissionValue;
      }

      final int numberOfTrackedDays = trackedDays.length;
      final int numberOfUntrackedDays = 365 -
          numberOfTrackedDays; 

      final double totalEstimatedEmissions =
          totalDailyEmissions / numberOfTrackedDays;
      final double totalYearEstimated = (totalEstimatedEmissions * 365) / 1000;

      return [totalTrackedEmissions, totalYearEstimated, totalDailyEmissions, totalEstimatedEmissions]; 
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            getCommonEmissions: getCommonEmissions(),
            getDateKey: getDateKey,
            updatePage: updateSelectedIndex,
          ),
          TrackCarbonScreen(
            getDateKey: getDateKey,
            updatePage: updateSelectedIndex,
            getCommonEmissions: getCommonEmissions(),
          ),
          ReduceEmissionsScreen(
            getCommonEmissions: getCommonEmissions(),
          ),
          const ActivismScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColours.bgOff,
        elevation: 10,
        onTap: _onItemTapped,
        selectedItemColor: AppColours.primaryAccent,
        selectedIconTheme: const IconThemeData(
          color: AppColours.primaryAccent,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColours.accentDark,
        ),
        unselectedItemColor: AppColours.accentDark,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
            key: Key('app_bar_home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome5.calculator,
            ),
            label: 'Track Emissions',
            key: Key('app_bar_track'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome5.tree,
            ),
            label: 'Reduce',
            key: Key('app_bar_reduce'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome5.exclamation,
            ),
            label: 'Blame',
            key: Key('app_bar_blame'),
          ),
        ],
      ),
    );
  }
}

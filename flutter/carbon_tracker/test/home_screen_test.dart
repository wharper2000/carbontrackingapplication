import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/assets/emission_values.dart';
import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:carbon_tracker/screens/app_bar_screen.dart';
import 'package:carbon_tracker/screens/home_screen.dart';
import 'package:carbon_tracker/screens/track_emissions_screen.dart';
import 'package:carbon_tracker/widgets/line_chart.dart';
import 'package:carbon_tracker/widgets/pie_chart.dart';
import 'package:carbon_tracker/widgets/recent_emissions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the generated mocks file
import 'shared_preferences_mock.mocks.dart';

void main() {
  testWidgets('HomeScreen displays correct title', (WidgetTester tester) async {
    // Create a mock function for getDateKey
    String Function(DateTime) getDateKey = (DateTime dateTime) => '';
    // Create a mock function for updatePage
    Function updatePage = () {};
    // Create a mock list for getCommonEmissions
    List<double> getCommonEmissions = [0, 0, 0, 0];
    // Create a provider container
    final container = ProviderContainer();
    // Build the HomeScreen widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
        ],
        child: MaterialApp(
          home: HomeScreen(
            getDateKey: getDateKey,
            updatePage: updatePage,
            getCommonEmissions: getCommonEmissions,
          ),
        ),
      ),
    );
    // Find the title in the app bar
    final titleFinder = find.text('Your Carbon Footprint');
    // Expect the title to be found 
    expect(titleFinder, findsOneWidget);
  });

  testWidgets('Homepage has correct widgets', (WidgetTester tester) async {
    // Create a mock function for getDateKey
    String Function(DateTime) getDateKey = (DateTime dateTime) => '';
    // Create a mock function for updatePage
    Function updatePage = () {};
    // Create a mock list for getCommonEmissions
    List<double> getCommonEmissions = [0, 0, 0, 0];
    // Create a provider container
    final container = ProviderContainer();
    // Build the HomeScreen widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
        ],
        child: MaterialApp(
          home: HomeScreen(
            getDateKey: getDateKey,
            updatePage: updatePage,
            getCommonEmissions: getCommonEmissions,
          ),
        ),
      ),
    );
    // Wait for the widgets to be built
    await tester.pumpAndSettle();
    // Test that the app bar exists
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(const Key('emissions_chart')),
        findsOneWidget); //Method one for testing if custom widgets exist
    expect(find.byWidgetPredicate((widget) => widget is RecentEmissions),
        findsOneWidget); //Method two for testing if custom widgets exist
    // Test that the button exists
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('Buttons navigate to correct pages', (WidgetTester tester) async {
    String Function(DateTime) getDateKey = (DateTime dateTime) => '';
    // Create a mock function for updatePage
    Function updatePage = () {};
    // Create a mock list for getCommonEmissions
    List<double> getCommonEmissions = [0, 0, 0, 0];
    // Create a provider container
    final container = ProviderContainer();
    // Build the HomeScreen widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
        ],
        child: MaterialApp(
          home: MyNavigationBar(),
        ),
      ),
    );
    // Wait for all animations to complete
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    // Find the button on the home screen
    final Finder homeScreenButton =
        find.byKey(const Key('primary_home_button'));
    // Ensure the button is visible
    await tester.ensureVisible(homeScreenButton);
    // Tap the button
    await tester.tap(homeScreenButton);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(find.byType(TrackCarbonScreen), findsOneWidget);
    print('Primary Home Screen Button Works');
    final Finder secondaryButton =
        find.byKey(const Key('secondary_home_button'));
    final Finder appBarHome = find.byKey(const Key('app_bar_home'));
    final Finder appBarTrack = find.byKey(const Key('app_bar_track'));
    final Finder appBarReduce = find.byKey(const Key('app_bar_reduce'));
    // Ensure the button is visible
    await tester.ensureVisible(appBarHome);
    // Tap the button
    await tester.tap(appBarHome);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(secondaryButton, findsOneWidget);
    print('App Bar Home Button Works');

    // Ensure the button is visible
    await tester.ensureVisible(appBarReduce);
    // Tap the button
    await tester.tap(appBarReduce);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(find.byType(MyPieChart), findsOneWidget);
    print('App Bar Reduce Button Works');

    // Ensure the button is visible
    await tester.ensureVisible(appBarTrack);
    // Tap the button
    await tester.tap(appBarTrack);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(find.byKey(const Key('tracking_screen')), findsOneWidget);
    print('App Bar Track Button Works');

    // Ensure the button is visible
    await tester.ensureVisible(appBarHome);
    // Tap the button
    await tester.tap(appBarHome);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(secondaryButton, findsOneWidget);

    // Ensure the button is visible
    await tester.ensureVisible(secondaryButton);
    // Tap the button
    await tester.tap(secondaryButton);
    // Wait for the app to update
    await tester.pumpAndSettle();
    // Check that the TrackCarbonScreen page is displayed
    expect(find.byType(MyPieChart), findsOneWidget);
    print('Secondary Home Secondary Button Works');
  });

//TESTING GETDATEKEY WITHIN MYNAVIGATIONBAR
  group('getDateKey', () {
    test('returns "Today" for today\'s date', () {
      final today = DateTime.now();
      expect(getDateKey(today), 'Today');
      print(getDateKey(today));
    });

    test('returns "Yesterday" for yesterday\'s date', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(getDateKey(yesterday), 'Yesterday');
      print(getDateKey(yesterday));
    });

    test('returns a formatted date string for other dates', () {
      final someDate = DateTime(2022, 6, 15);
      expect(getDateKey(someDate), '15/6/2022');
      print(getDateKey(someDate));
    });
  });

  testWidgets('addEmissionItem adds an item to the list',
      (WidgetTester tester) async {
    // Create a mock emission item notifier
    final emissionItemNotifier = MockEmissionItemNotifier();
    // Create a test widget that calls addEmissionItem
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            child: Text('Add Emission Item'),
            onPressed: () {
              emissionItemNotifier.addEmissionItem(EmissionItem(
                  timestamp: DateTime.now(),
                  emissionValue: 10.0,
                  category: EmissionCategories.passengerVehicle,
                  type: CarTypePetrol.lowerMedium));
            },
          ),
        ),
      ),
    );
    // Check that the list is initially empty
    expect(emissionItemNotifier.state, isEmpty);
    // Press the button to add an emission item
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // Check that the list now contains one item
    expect(emissionItemNotifier.state, hasLength(1));
    // Check that the item was added correctly
    expect(emissionItemNotifier.state.first.emissionValue, 10.0);
    expect(emissionItemNotifier.state.first.category,
        EmissionCategories.passengerVehicle);
  });

  testWidgets('calculateEmissionsGeneral calculates emission value for item',
      (WidgetTester tester) async {
    //In RecentEmissionsScreen
    double totalEmissions = 0.0;
    double? _calculateEmissionsGeneral(double value) {
      double? emissionFactor;
      emissionFactor = allEmissionValues[FoodType.apples];
      if (emissionFactor != null) {
        // Process the emission factor with the provided value
        print('Emissions in kg/Co2');
        totalEmissions = (value * emissionFactor);
        return totalEmissions;
      }
      return null;
    }
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            child: Text('Calculate Emissions'),
            onPressed: () {
              totalEmissions = _calculateEmissionsGeneral(2.5)!;
            },
          ),
        ),
      ),
    );
    // Verify that the button is pressed
    await tester.tap(find.byType(ElevatedButton));
    // Verify that the _calculateEmissionsGeneral method is called
    expect(totalEmissions, isNotNull);
    // Verify that the result is correct
    double expectedEmissions = 2.5 * allEmissionValues[FoodType.apples]!;
    expect(totalEmissions, closeTo(expectedEmissions, 0.01));
  });

  testWidgets('removeEmissionItem removes an item in the list',
      (WidgetTester tester) async {
    // Create a mock emission item notifier
    final emissionItemNotifier = MockEmissionItemNotifier();
    // Add some emission items to the list
    emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium));
    emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 20.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium));
    // Create a test widget that calls removeEmissionItem
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            child: Text('Remove Emission Item'),
            onPressed: () {
              emissionItemNotifier
                  .removeEmissionItem(emissionItemNotifier.state[0]);
            },
          ),
        ),
      ),
    );
    // Check that the list initially contains two items
    expect(emissionItemNotifier.state, hasLength(2));
    // Press the button to remove an emission item
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // Check that the list now contains one item
    expect(emissionItemNotifier.state, hasLength(1));
    // Check that the first item was removed
    expect(emissionItemNotifier.state.first.emissionValue, 20.0);
  });

  testWidgets('addEmissionItemAt adds an item to the list at a specific index',
      (WidgetTester tester) async {
    // Create a mock emission item notifier
    final emissionItemNotifier = MockEmissionItemNotifier();
    // Add some items to the list initially
    emissionItemNotifier.state = [
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 5.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 15.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
    ];
    // Create a test widget that calls addEmissionItemAt
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            child: Text('Add Emission Item at Index 1'),
            onPressed: () {
              emissionItemNotifier.addEmissionItemAt(
                1,
                EmissionItem(
                  timestamp: DateTime.now(),
                  emissionValue: 10.0,
                  category: EmissionCategories.passengerVehicle,
                  type: CarTypePetrol.lowerMedium,
                ),
              );
            },
          ),
        ),
      ),
    );
    // Check that the list initially has 2 items
    expect(emissionItemNotifier.state, hasLength(2));
    // Press the button to add an emission item at index 1
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // Check that the list now contains 3 items
    expect(emissionItemNotifier.state, hasLength(3));
    // Check that the item was added correctly at index 1
    expect(emissionItemNotifier.state[1].emissionValue, 10.0);
    expect(emissionItemNotifier.state[1].category,
        EmissionCategories.passengerVehicle);
  });

  group('SharedPreferences', () {
    late CustomMockSharedPreferences mockSharedPreferences;
    setUp(() {
      mockSharedPreferences = CustomMockSharedPreferences();
    });
    test('should save and retrieve a value', () async {
      when(mockSharedPreferences.getString('key')).thenReturn('value');
      when(mockSharedPreferences.setString('key', 'value'))
          .thenAnswer((_) async => true);

      final value = mockSharedPreferences.getString('key');
      final result = await mockSharedPreferences.setString('key', 'value');

      expect(value, 'value');
      expect(result, true);
      verify(mockSharedPreferences.getString('key')).called(1);
      verify(mockSharedPreferences.setString('key', 'value')).called(1);
    });
  });

  group('getTodayEmissions', () {
    test('returns the sum of emission values for today\'s items', () {
      final emissionItemNotifier =
          MockEmissionItemNotifier(); // Create a new instance
      emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 5.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ));
      emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ));
      emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        emissionValue: 20.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      )); // yesterday's item
      final todayEmissions = emissionItemNotifier.getTodayEmissions();
      expect(todayEmissions, 15.0); // 5.0 + 10.0
    });

    test('returns 0 when there are no items for today', () {
      final emissionItemNotifier =
          MockEmissionItemNotifier(); // Create a new instance

      emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ));
      emissionItemNotifier.addEmissionItem(EmissionItem(
        timestamp: DateTime.now().add(const Duration(days: 1)),
        emissionValue: 20.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ));
      final todayEmissions = emissionItemNotifier.getTodayEmissions();
      expect(todayEmissions, 0.0);
    });
  });
  test('returns a list of emission items for today', () {
    final emissionItemNotifier = MockEmissionItemNotifier();
    final state = [
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 5.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        emissionValue: 20.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ), // yesterday's item
      EmissionItem(
        timestamp: DateTime.now().add(const Duration(days: 1)),
        emissionValue: 30.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ), // tomorrow's item
    ];
    final todayEmissionItems =
        emissionItemNotifier.getTodayEmissionItems(state);
    expect(todayEmissionItems.length, 2);
    expect(todayEmissionItems[0].emissionValue, 5.0);
    expect(todayEmissionItems[1].emissionValue, 10.0);
  });

  test('calculates total emissions per category', () {
    final emissionItemNotifier = MockEmissionItemNotifier();
    final items = [
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 5.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 20.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 30.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 15.0,
        category: EmissionCategories.flight,
        type: CarTypePetrol.lowerMedium,
      ),
    ];
    final categoryEmissions =
        emissionItemNotifier.calculateCategoryEmissions(items);
    expect(categoryEmissions, {
      EmissionCategories.passengerVehicle: 65.0,
      EmissionCategories.flight: 15.0,
    });
  });

  test('calculates combined category emissions', () {
    final emissionItemNotifier = MockEmissionItemNotifier();

    final items = [
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 5.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 10.0,
        category: EmissionCategories.passengerVehicle,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 20.0,
        category: EmissionCategories.bus,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 30.0,
        category: EmissionCategories.train,
        type: CarTypePetrol.lowerMedium,
      ),
      EmissionItem(
        timestamp: DateTime.now(),
        emissionValue: 15.0,
        category: EmissionCategories.flight,
        type: CarTypePetrol.lowerMedium,
      ),
    ];

    final combinedEmissions =
        emissionItemNotifier.calculateCombinedCategoryEmissions(items);

    expect(combinedEmissions, {
      EmissionCategories.passengerVehicle: 65.0,
      EmissionCategories.flight: 15.0,
    });
  });

  testWidgets('MyPieChart displays pie chart with correct data',
      (tester) async {
    // Create a list of emission items for testing
    final emissionItems = [
      EmissionItem(
        category: EmissionCategories.bus,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
        type: BusType.averageLocalBus,
      ),
      EmissionItem(
          category: EmissionCategories.flight,
          emissionValue: 20.0,
          timestamp: DateTime.now(),
          type: FlightType.domestic),
      EmissionItem(
        category: EmissionCategories.food,
        emissionValue: 30.0,
        timestamp: DateTime.now(),
        type: FoodType.apples,
      ),
    ];
    // Create a provider for the emission items
    final emissionItemNotifier = MockEmissionItemNotifier();
    final emissionItemProvider = Provider((ref) => MockEmissionItemNotifier());
    // Create a key for the PieChart widget
    final pieChartKey = GlobalKey();
    // Pump the widget into the test environment
    await tester.pumpWidget(
      ProviderScope(
        overrides: [emissionItemProvider],
        child: MaterialApp(
          home: MyPieChart(
            key: pieChartKey, // Assign the key to the PieChart widget
            emissionItems: emissionItems,
          ),
        ),
      ),
    );
    expect(find.byType(PieChart), findsOneWidget);
    // Get the PieChartData object
    final pieChartWidget = tester.widget<PieChart>(find.byType(PieChart));
    final pieChartData = pieChartWidget.data;
    // Verify that the correct number of sections are displayed
    expect(pieChartData.sections.length, emissionItems.length);
    // Verify that the section values are correct
    for (int i = 0; i < emissionItems.length; i++) {
      final section = pieChartData.sections.elementAt(i);
      expect(section.value, emissionItems[i].emissionValue);
    }
  });

  testWidgets('EmissionsChart displays line chart with correct data',
    (tester) async {
  // Create a list of emission items for testing
  final emissionItems = [
    EmissionItem(
      category: EmissionCategories.bus,
      emissionValue: 10.0,
      timestamp: DateTime.now(),
      type: BusType.averageLocalBus,
    ),
    EmissionItem(
      category: EmissionCategories.flight,
      emissionValue: 20.0,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      type: FlightType.domestic,
    ),
    EmissionItem(
      category: EmissionCategories.food,
      emissionValue: 30.0,
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      type: FoodType.apples,
    ),
  ];
  // Create a provider for the emission items
  final emissionItemNotifier = MockEmissionItemNotifier();
  final emissionItemProvider = Provider((ref) => MockEmissionItemNotifier());
  // Create a key for the EmissionsChart widget
  final emissionsChartKey = GlobalKey();
  // Pump the widget into the test environment
  await tester.pumpWidget(
    ProviderScope(
      overrides: [emissionItemProvider],
      child: MaterialApp(
        home: EmissionsChart(
          key: emissionsChartKey, // Assign the key to the EmissionsChart widget
          emissionItems: emissionItems,
          totalEstimatedEmissions: 100.0,
        ),
      ),
    ),
  );
  expect(find.byType(LineChart), findsOneWidget);
  // Get the LineChartData object
  final lineChartWidget = tester.widget<LineChart>(find.byType(LineChart));
  final lineChartData = lineChartWidget.data;
  // Verify that the correct number of line bars are displayed
  expect(lineChartData.lineBarsData.length, 2);
  // Verify that the line chart data is correct
  final chartData = generateChartData(emissionItems);
  final averageData = generateAverageEmissionsData(100.0);
  for (int i = 0; i < chartData.length; i++) {
    expect(lineChartData.lineBarsData[0].spots.elementAt(i).y, chartData[i].y);
  }
  for (int i = 0; i < averageData.length; i++) {
    expect(lineChartData.lineBarsData[1].spots.elementAt(i).y, averageData[i].y);
  }
});

} 

class MockSharedPreferences extends Mock implements SharedPreferences {}
// Mock emission item notifier class
class MockEmissionItemNotifier with Mock {
  @override
  List<EmissionItem> state = [];
  void addEmissionItem(EmissionItem item) {
    state.add(item);
  }
  void removeEmissionItem(EmissionItem item) {
    state.remove(item);
  }
  Future<void> addEmissionItemAt(int index, EmissionItem item) async {
    final List<EmissionItem> updatedList = List.from(state);
    updatedList.insert(index, item);
    state = updatedList;
  }
  double getTodayEmissions() {
    final today = DateTime.now();
    final todayItems = state
        .where((item) =>
            item.timestamp.year == today.year &&
            item.timestamp.month == today.month &&
            item.timestamp.day == today.day)
        .toList();
    return todayItems.fold(0, (sum, item) => sum + item.emissionValue);
  }
  List<EmissionItem> getTodayEmissionItems(List<EmissionItem> state) {
    final today = DateTime.now();
    return state
        .where((item) =>
            item.timestamp.year == today.year &&
            item.timestamp.month == today.month &&
            item.timestamp.day == today.day)
        .toList();
  }
  Map<EmissionCategories, double> calculateCategoryEmissions(
      List<EmissionItem> items) {
    // Initialize map to store total emissions per category
    Map<EmissionCategories, double> categoryEmissions = {};
    for (var item in items) {
      var category = item.category;
      var emissionValue = item.emissionValue;
      if (categoryEmissions.containsKey(category)) {
        categoryEmissions[category] =
            (categoryEmissions[category] ?? 0) + emissionValue;
      } else {
        categoryEmissions[category] = emissionValue;
      }
    }
    return categoryEmissions;
  }
  Map<EmissionCategories, double> calculateCombinedCategoryEmissions(
      List<EmissionItem> items) {
    var emissionsByCategory = calculateCategoryEmissions(items);
    // Combine specific categories into 'Vehicle'
    double vehicleEmissions =
        emissionsByCategory[EmissionCategories.passengerVehicle] ?? 0.0;
    vehicleEmissions += emissionsByCategory[EmissionCategories.bus] ?? 0.0;
    vehicleEmissions += emissionsByCategory[EmissionCategories.train] ?? 0.0;
    // Replace individual category emissions with combined 'Vehicle' emissions
    emissionsByCategory[EmissionCategories.passengerVehicle] = vehicleEmissions;
    // Remove individual categories that were combined
    emissionsByCategory.remove(EmissionCategories.bus);
    emissionsByCategory.remove(EmissionCategories.train);
    return emissionsByCategory;
  }
}

import 'dart:convert';

import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/assets/emission_values.dart';
import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('EmissionItemNotifier', () {
    late EmissionItemNotifier _emissionItemNotifier;

    late SharedPreferences _prefs;

    setUp(() async {
      _prefs = await SharedPreferences.getInstance();

      _emissionItemNotifier = EmissionItemNotifier();
    });

    tearDown(() {
      _prefs.clear();
    });

    test('initial state is empty', () {
      expect(_emissionItemNotifier.state, isEmpty);
    });

    test('addEmissionItem adds item to state', () async {
      final item = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      await _emissionItemNotifier.addEmissionItem(item);

      expect(_emissionItemNotifier.state, contains(item));
    });

    test('removeEmissionItem removes item from state', () async {
      final item = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      await _emissionItemNotifier.addEmissionItem(item);

      await _emissionItemNotifier.removeEmissionItem(0);

      expect(_emissionItemNotifier.state, isEmpty);
    });

    test('saveEmissionItems saves items to SharedPreferences', () async {
      final item = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      await _emissionItemNotifier.addEmissionItem(item);

      await _emissionItemNotifier.saveEmissionItems();

      final jsonString = _prefs.getString('emissionItems');

      expect(jsonString, isNotNull);

      final jsonList = jsonDecode(jsonString!) as List<dynamic>;

      expect(jsonList, hasLength(1));
    });

    test('loadEmissionItems loads items from SharedPreferences', () async {
      final item = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      final jsonString = jsonEncode([item.toJson()]);

      _prefs.setString('emissionItems', jsonString);

      await _emissionItemNotifier.loadEmissionItems();

      expect(_emissionItemNotifier.state, contains(item));
    });

    test('getTodayEmissions returns today\'s emissions', () {
      final item1 = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      final item2 = EmissionItem(
        type:CarTypePetrol,
        category: EmissionCategories.passengerVehicle,
        emissionValue: 20.0,
        timestamp: DateTime.now(),
      );

      _emissionItemNotifier.state = [item1, item2];

      expect(_emissionItemNotifier.getTodayEmissions(), 30.0);
    });

    test('calculateCategoryEmissions returns emissions by category', () {
      final item1 = EmissionItem(
        type: FoodType,
        category: EmissionCategories.food,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      final item2 = EmissionItem(
        type: CarTypePetrol,
        category: EmissionCategories.passengerVehicle,
        emissionValue: 20.0,
        timestamp: DateTime.now(),
      );

      final items = [item1, item2];

      final categoryEmissions =
          _emissionItemNotifier.calculateCategoryEmissions(items);

      expect(categoryEmissions, {
        EmissionCategories.food: 10.0,
        EmissionCategories.passengerVehicle: 20.0,
      });
    });

    test(
        'calculateCombinedCategoryEmissions returns combined emissions by category',
        () {
      final item1 = EmissionItem(
        type: CarTypePetrol,
        category: EmissionCategories.passengerVehicle,
        emissionValue: 10.0,
        timestamp: DateTime.now(),
      );

      final item2 = EmissionItem(
        type: BusType,
        category: EmissionCategories.bus,
        emissionValue: 20.0,
        timestamp: DateTime.now(),
      );

      final item3 = EmissionItem(
        type: TrainType,
        category: EmissionCategories.train,
        emissionValue: 30.0,
        timestamp: DateTime.now(),
      );

      final items = [item1, item2, item3];

      final categoryEmissions =
          _emissionItemNotifier.calculateCombinedCategoryEmissions(items);

      expect(categoryEmissions, {
        EmissionCategories.passengerVehicle: 60.0,
      });
    });
  });
}

final emissionItemProvider =
    StateNotifierProvider<EmissionItemNotifier, List<EmissionItem>>((ref) {
  return EmissionItemNotifier();
});

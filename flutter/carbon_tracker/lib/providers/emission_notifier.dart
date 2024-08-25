import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:collection/collection.dart'; // For grouping utilities
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'emission_item.dart';

class EmissionItemNotifier extends StateNotifier<List<EmissionItem>> {
  EmissionItemNotifier() : super([]) {
    loadEmissionItems();
  }

  Future<void> addEmissionItem(EmissionItem item) async {
    state = [...state, item];
    await saveEmissionItems();
  }

  Future<void> removeEmissionItem(int index) async {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    await saveEmissionItems();
  }

  Future<void> saveEmissionItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString('emissionItems', jsonString);
  }

  Future<void> loadEmissionItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('emissionItems');
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      state =
          jsonList.map((jsonItem) => EmissionItem.fromJson(jsonItem)).toList();
    }
  }

  // Define the addEmissionItemAt method
  Future<void> addEmissionItemAt(int index, EmissionItem item) async {
    final List<EmissionItem> updatedList = List.from(state);
    updatedList.insert(index, item);
    state = updatedList;
    await saveEmissionItems();
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

    Map<EmissionCategories, double> calculateCategoryEmissions(
        List<EmissionItem> items) {
      // Initialize map to store total emissions per category
      Map<EmissionCategories, double> categoryEmissions = {};
      // Loop through each emission item and aggregate emissions by category
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

final emissionItemProvider =
    StateNotifierProvider<EmissionItemNotifier, List<EmissionItem>>((ref) {
  return EmissionItemNotifier();
});

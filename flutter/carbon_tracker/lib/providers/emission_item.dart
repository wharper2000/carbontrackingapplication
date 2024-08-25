import 'package:carbon_tracker/assets/emission_categories.dart';
import 'dart:convert';

import 'package:carbon_tracker/assets/emission_values.dart';

class EmissionItem {
  final EmissionCategories category;
  final dynamic type;
  final double emissionValue;
  final DateTime timestamp;

  EmissionItem({
    required this.category,
    required this.type,
    required this.emissionValue,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category.toString(),
      'type': type.toString(), // Convert enum to string
      'emissionValue': emissionValue,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory EmissionItem.fromJson(Map<String, dynamic> json) {
    return EmissionItem(
      category: EmissionCategories.values
          .firstWhere((e) => e.toString() == json['category']),
      type: _stringToEnum(json['type']),
      emissionValue: json['emissionValue'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  static dynamic _stringToEnum(String enumString) {
    if (enumString.contains('FlightType')) {
      return FlightType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('BusType')) {
      return BusType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('TrainType')) {
      return TrainType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('BatteryElectric')) {
      return BatteryElectric.values
          .firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('HybridElectric')) {
      return HybridElectric.values
          .firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('CarTypeDiesel')) {
      return CarTypeDiesel.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('CarTypePetrol')) {
      return CarTypePetrol.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('DietaryType')) {
      return DietaryType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('FuelType')) {
      return FuelType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('FoodType')) {
      return FoodType.values.firstWhere((e) => e.toString() == enumString);
    } else if (enumString.contains('HouseholdAppliance')) {
      return HouseholdAppliance.values.firstWhere((e) => e.toString() == enumString);
    } else {
      throw Exception('Unknown enum type');
    }
  }
}

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final String nameDisplay;
  final double electricityEmissions;
  final double gasEmissions;
  final double fuelEmissions;
  final double foodEmissions;
  final double vehicleEmissions;
  final double trainEmissions;
  final double busEmissions;
  final double flightEmissions;

  UserInfo({
    required this.nameDisplay,
    required this.electricityEmissions,
    required this.gasEmissions,
    required this.fuelEmissions,
    required this.foodEmissions,
    required this.vehicleEmissions,
    required this.trainEmissions,
    required this.busEmissions,
    required this.flightEmissions,
  });

  double get totalEmissions => electricityEmissions + gasEmissions + fuelEmissions + foodEmissions + vehicleEmissions + trainEmissions + busEmissions + flightEmissions;

  // Convert user info to a JSON map to save in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'name': nameDisplay,
      'electricityEmissions': electricityEmissions,
      'gasEmissions': gasEmissions,
      'fuelEmissions': fuelEmissions,
      'foodEmissions': foodEmissions,
      'vehicleEmissions': vehicleEmissions,
      'trainEmissions': trainEmissions,
      'busEmissions': busEmissions,
      'flightEmissions': flightEmissions,
      'totalEmissions': totalEmissions,
    };
  }
    // Create UserInfo from JSON map retrieved from SharedPreferences
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      nameDisplay: json['name'],
      electricityEmissions: json['electricityEmissions'],
      gasEmissions: json['gasEmissions'],
      fuelEmissions: json['fuelEmissions'],
      foodEmissions: json['foodEmissions'],
      vehicleEmissions: json['vehicleEmissions'],
      trainEmissions: json['trainEmissions'],
      busEmissions: json['busEmissions'],
      flightEmissions: json['flightEmissions'],
      // Initialize other fields here
    );
  }

}

class UserInfoNotifier extends StateNotifier<UserInfo> {
  UserInfoNotifier() : super(UserInfo(
    nameDisplay: '',
    electricityEmissions: 0,
    gasEmissions: 0,
    fuelEmissions: 0,
    foodEmissions: 0,
    vehicleEmissions: 0,
    trainEmissions: 0,
    busEmissions: 0,
    flightEmissions: 0,
  )) {
    loadUserInfo(); // Ensure user info is loaded on initialization
  }

  // Function to save user info to SharedPreferences
  Future<void> saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(state.toJson()));
  }

  // Function to load user info from SharedPreferences
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userInfo');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      state = UserInfo.fromJson(jsonMap);
    }
  }

  // Update method to update emissions and save to SharedPreferences
  void updateEmissions({
    String? name,
    double? electricity,
    double? gas,
    double? fuel,
    double? food,
    double? vehicle,
    double? train,
    double? bus,
    double? flight,
  }) {
    state = UserInfo(
      nameDisplay: name ?? state.nameDisplay,
      electricityEmissions: electricity ?? state.electricityEmissions,
      gasEmissions: gas ?? state.gasEmissions,
      fuelEmissions: fuel ?? state.fuelEmissions,
      foodEmissions: food ?? state.foodEmissions,
      vehicleEmissions: vehicle ?? state.vehicleEmissions,
      trainEmissions: train ?? state.trainEmissions,
      busEmissions: bus ?? state.busEmissions,
      flightEmissions: flight ?? state.flightEmissions,
    );
    saveUserInfo(); // Save updated info after setting state
  }
}


final userInfoProvider = StateNotifierProvider<UserInfoNotifier, UserInfo>((ref) {
  return UserInfoNotifier();
});

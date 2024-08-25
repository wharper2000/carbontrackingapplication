// test/shared_preferences_mock.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SharedPreferences], customMocks: [MockSpec<SharedPreferences>(as: #CustomMockSharedPreferences)])
void main() {}

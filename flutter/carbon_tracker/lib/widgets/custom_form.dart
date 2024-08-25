import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/providers/user_info.dart';
import 'package:carbon_tracker/screens/app_bar_screen.dart';
import 'package:carbon_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carbon_tracker/assets/emission_values.dart';

class MyCustomForm extends ConsumerStatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends ConsumerState<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _householdController = TextEditingController();
  final _electricityController = TextEditingController();
  final _electricityOffsetController = TextEditingController();
  final _gasController = TextEditingController();
  final _fuelQuantityController = TextEditingController();
  final _carMileageController = TextEditingController();
  final _trainDistanceController = TextEditingController();
  final _busDistanceController = TextEditingController();
  final _flightDistanceController = TextEditingController();
  final _electricityConversionFactor = 0.20496;
  final _gasConversionFactor = 2.03437;

  FuelType? _selectedFuelType;
  DietaryType? _selectedDietaryType;
  CarType? _selectedCarType;
  CarTypePetrol? _selectedCarTypePetrol;
  CarTypeDiesel? _selectedCarTypeDiesel;
  HybridElectric? _selectedHybridElectric;
  BatteryElectric? _selectedBatteryElectric;
  TrainType? _selectedTrainType;
  BusType? _selectedBusType;
  FlightType? _selectedFlightType;
  bool? _isElectricityGreen;
  bool? _hasSolarPanels;
  bool? _usesAlternativeHeating;

  @override
  void dispose() {
    /*
    In Flutter, the dispose() method is called automatically by the framework when a State 
    object is removed from the widget tree permanently. 
    This typically happens when the widget is no longer needed, for example, 
    when navigating away from a screen or when the parent widget rebuilds and 
    decides not to include the current widget in the new tree.
    */
    _nameController.dispose();
    _householdController.dispose();
    _electricityController.dispose();
    _electricityOffsetController.dispose();
    _gasController.dispose();
    _fuelQuantityController.dispose();
    _carMileageController.dispose();
    _trainDistanceController.dispose();
    _busDistanceController.dispose();
    _flightDistanceController.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save form data or process as needed
      print('Form saved successfully!');
      _calculateEmissions();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyNavigationBar(),
        ),
      );
    }
  }

  void _calculateEmissions() {
    final userInfoNotifier = ref.read(userInfoProvider.notifier);
    _electricityController.text =
        _convertUnusedValues(_electricityController.text);
    _electricityOffsetController.text =
        _convertUnusedValues(_electricityOffsetController.text);
    _fuelQuantityController.text =
        _convertUnusedValues(_fuelQuantityController.text);
    //print(int.tryParse(_electricityController.text)! + int.tryParse(_electricityOffsetController.text)! + int.tryParse(_fuelQuantityController.text)!);
    double electricityHousehold = double.parse(_electricityController.text) /
        double.parse(_householdController.text);
    final electricityOffset =
        (1 - (double.parse(_electricityOffsetController.text) / 100)) / 1000;
    double electricityEmissions = electricityHousehold *
        _electricityConversionFactor *
        12 *
        electricityOffset;
    //Electricity Emissions ^
    //print(electricityOffset);

    print('Electricity: $electricityEmissions');

    double gasHousehold = int.parse(_gasController.text) /
        double.parse(_householdController.text);
    double gasEmissions = (gasHousehold * _gasConversionFactor) * 12 / 1000;
    //print(gasHousehold);
    print('Gas: $gasEmissions');
    //^gas Emissions

    var alternativeEmissions = 0.0;
    if (_usesAlternativeHeating == true) {
      alternativeEmissions = (fuelTypeValues[_selectedFuelType]! *
              double.parse(_fuelQuantityController.text)) /
          1000;
    }
    print('Alternative: $alternativeEmissions');
    //^Alternative Fuel Emissions

    final double dietEmissions =
        dietaryTypeValues[_selectedDietaryType]! * 2 * 365.25 / 1000;
    print('Food: $dietEmissions');
    //^Diet Emissions

    double vehicleEmissions = 0.0;
    if (_selectedCarType == CarType.petrol) {
      vehicleEmissions = (carTypePetrolValues[_selectedCarTypePetrol]! *
              double.parse(_carMileageController.text) *
              12) /
          1000;
    } else if (_selectedCarType == CarType.diesel) {
      vehicleEmissions = (carTypeDieselValues[_selectedCarTypeDiesel]! *
              double.parse(_carMileageController.text) *
              12) /
          1000;
    } else if (_selectedCarType == CarType.batteryElectric) {
      vehicleEmissions = (batteryElectricValues[_selectedBatteryElectric]! *
              double.parse(_carMileageController.text) *
              12) /
          1000;
    } else if (_selectedCarType == CarType.hybridElectric) {
      vehicleEmissions = (hybridElectricValues[_selectedHybridElectric]! *
              double.parse(_carMileageController.text) *
              12) /
          1000;
    }
    print('Vehicle: $vehicleEmissions');
    //^Vehicle Emissions

    final double trainEmissions = trainTypeValues[_selectedTrainType]! *
        double.parse(_trainDistanceController.text) *
        12 /
        1000;
    print('Train: $trainEmissions');
    //^Train Emissions

    final busEmissions = busTypeValues[_selectedBusType]! *
        double.parse(_busDistanceController.text) *
        12 /
        1000;
    print('Bus: $busEmissions');
    //^Bus Emissions

    final flightEmissions = flightTypeValues[_selectedFlightType]! *
        double.parse(_flightDistanceController.text) /
        100;
    print('Flight: $flightEmissions');
    final totalEmissions = flightEmissions + busEmissions + trainEmissions +vehicleEmissions+ dietEmissions + alternativeEmissions +gasEmissions + electricityEmissions;
    print('Total Emissions are: $totalEmissions');

    userInfoNotifier.updateEmissions(
      name: _nameController.text,
      electricity: electricityEmissions,
      gas: gasEmissions,
      fuel: alternativeEmissions,
      food: dietEmissions,
      vehicle: vehicleEmissions,
      train: trainEmissions,
      bus: busEmissions,
      flight: flightEmissions,
    );
    //final userInfo = ref.read(userInfoProvider);
    //print('BUS PROVIDER');
    //print(userInfo.busEmissions);
    //^THIS WORKS
  }

  String _convertUnusedValues(variable) {
    final isNull = int.tryParse(variable);
    if (isNull == null) {
      variable = '0';
    }
    return variable;
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.parse(value) < 0) {
      return 'Please enter a valid positive number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 24),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: "What's your name?"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _householdController,
                  decoration: const InputDecoration(
                      labelText: 'How many people live in your household?'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<bool>(
                  value: _isElectricityGreen,
                  decoration: const InputDecoration(
                      labelText: 'Is your electricity green?'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Yes')),
                    DropdownMenuItem(value: false, child: Text('No')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isElectricityGreen = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                if (_isElectricityGreen == false)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _electricityController,
                        decoration: const InputDecoration(
                            labelText: 'Electricity usage (kWh/month)'),
                        keyboardType: TextInputType.number,
                        validator: _validatePositiveNumber,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<bool>(
                  value: _hasSolarPanels,
                  decoration: const InputDecoration(
                      labelText: 'Do you have solar panels?'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Yes')),
                    DropdownMenuItem(value: false, child: Text('No')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _hasSolarPanels = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                if (_hasSolarPanels == true)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _electricityOffsetController,
                        decoration: const InputDecoration(
                            labelText:
                                'Percentage of electricity offset by solar panels'),
                        keyboardType: TextInputType.number,
                        validator: _validatePositiveNumber,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _gasController,
                  decoration: const InputDecoration(
                      labelText: 'Gas usage (cubic metres/month)'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<bool>(
                  value: _usesAlternativeHeating,
                  decoration: const InputDecoration(
                      labelText: 'Do you use alternative heating?'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Yes')),
                    DropdownMenuItem(value: false, child: Text('No')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _usesAlternativeHeating = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                if (_usesAlternativeHeating == true)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<FuelType>(
                        value: _selectedFuelType,
                        decoration: const InputDecoration(
                            labelText: 'Primary alternative fuel source'),
                        items: FuelType.values
                            .map((fuel) => DropdownMenuItem<FuelType>(
                                  value: fuel,
                                  child: Text(fuelTypeDisplayNames[
                                      fuel]!), //Using Display name to improve user experience
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFuelType =
                                value; //Save the enum type to use for calculations later
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _fuelQuantityController,
                        decoration: const InputDecoration(
                            labelText: 'Fuel quantity (tonnes/year)'),
                        keyboardType: TextInputType.number,
                        validator: _validatePositiveNumber,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<DietaryType>(
                  value: _selectedDietaryType,
                  decoration: const InputDecoration(
                      labelText: 'Average weekly meat consumption'),
                  items: DietaryType.values
                      .map((diet) => DropdownMenuItem<DietaryType>(
                            value: diet,
                            child: Text(dietaryTypeDisplayNames[diet]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDietaryType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<CarType>(
                  value: _selectedCarType,
                  decoration: const InputDecoration(
                      labelText: 'What is Your Primary Vehicle Fuel Type?'),
                  items: CarType.values
                      .map((type) => DropdownMenuItem<CarType>(
                            value: type,
                            child: Text(carTypeDisplayNames[type]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCarType = value;
                      print(_selectedCarType);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                if (_selectedCarType == CarType.petrol)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<CarTypePetrol>(
                        value: _selectedCarTypePetrol,
                        decoration: const InputDecoration(
                            labelText: 'Primary petrol vehicle'),
                        items: CarTypePetrol.values
                            .map((petrol) => DropdownMenuItem<CarTypePetrol>(
                                  value: petrol,
                                  child:
                                      Text(carTypePetrolDisplayNames[petrol]!),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCarTypePetrol = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                if (_selectedCarType == CarType.diesel)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<CarTypeDiesel>(
                        value: _selectedCarTypeDiesel,
                        decoration: const InputDecoration(
                            labelText: 'Primary diesel vehicle'),
                        items: CarTypeDiesel.values
                            .map((diesel) => DropdownMenuItem<CarTypeDiesel>(
                                  value: diesel,
                                  child:
                                      Text(carTypeDieselDisplayNames[diesel]!),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCarTypeDiesel = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                if (_selectedCarType == CarType.hybridElectric)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<HybridElectric>(
                        value: _selectedHybridElectric,
                        decoration: const InputDecoration(
                            labelText: 'Primary Hybrid Electric vehicle'),
                        items: HybridElectric.values
                            .map((hybrid) => DropdownMenuItem<HybridElectric>(
                                  value: hybrid,
                                  child:
                                      Text(hybridElectricDisplayNames[hybrid]!),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHybridElectric = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                if (_selectedCarType == CarType.batteryElectric)
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<BatteryElectric>(
                        value: _selectedBatteryElectric,
                        decoration: const InputDecoration(
                            labelText: 'Primary Battery Electric vehicle'),
                        items: BatteryElectric.values
                            .map((battery) => DropdownMenuItem<BatteryElectric>(
                                  value: battery,
                                  child: Text(
                                      batteryElectricDisplayNames[battery]!),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBatteryElectric = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _carMileageController,
                  decoration: const InputDecoration(
                      labelText: 'Car mileage (km/month, if none enter 0)'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<TrainType>(
                  value: _selectedTrainType,
                  decoration:
                      const InputDecoration(labelText: 'Primary train type'),
                  items: TrainType.values
                      .map((train) => DropdownMenuItem<TrainType>(
                            value: train,
                            child: Text(trainTypeDisplayNames[train]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTrainType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _trainDistanceController,
                  decoration: const InputDecoration(
                      labelText: 'Train distance (km/month)'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<BusType>(
                  value: _selectedBusType,
                  decoration:
                      const InputDecoration(labelText: 'Primary bus type'),
                  items: BusType.values
                      .map((bus) => DropdownMenuItem<BusType>(
                            value: bus,
                            child: Text(busTypeDisplayNames[bus]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBusType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _busDistanceController,
                  decoration: const InputDecoration(
                      labelText: 'Bus distance (km/month)'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<FlightType>(
                  value: _selectedFlightType,
                  decoration:
                      const InputDecoration(labelText: 'Primary flight type'),
                  items: FlightType.values
                      .map((flight) => DropdownMenuItem<FlightType>(
                            value: flight,
                            child: Text(flightTypeDisplayNames[flight]!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFlightType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _flightDistanceController,
                  decoration: const InputDecoration(
                      labelText: 'Flight distance (km/year)'),
                  keyboardType: TextInputType.number,
                  validator: _validatePositiveNumber,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child:
                   ElevatedButton(
                      onPressed: () {
                        _saveForm(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColours.primaryAccent),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        elevation: WidgetStatePropertyAll(8),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

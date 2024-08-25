import 'dart:ffi';

import 'package:carbon_tracker/assets/colours.dart';
import 'package:carbon_tracker/assets/emission_categories.dart';
import 'package:carbon_tracker/assets/emission_values.dart';
import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:carbon_tracker/providers/emission_notifier.dart';
import 'package:carbon_tracker/screens/app_bar_screen.dart';
import 'package:carbon_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';

class NewEmissionScreen extends ConsumerStatefulWidget {
  const NewEmissionScreen({
    required this.updatePage,
    super.key,
  });

  final Function updatePage;
  @override
  ConsumerState<NewEmissionScreen> createState() => _NewEmissionScreenState();
}

class _NewEmissionScreenState extends ConsumerState<NewEmissionScreen> {
  int? _selectedIndex;
  int? _fuelTypeIndex;
  CarType? _carType;
  Map? _carFuelType;
  int? _carEmissionIndex;
  var _carEmissionItem; //is var as will be different enum values
  double? _emissionScalar;
  String? _positive;
  double? _totalEmissions;

  int? _generalEmissionIndex;
  var _generalEmissionItem;
  bool _selectedEmissionItem = false;
  String? _generalEmissionUnit;
  String? _unitTitle;
  EmissionCategories? _emissioncategory;

  final _formKey = GlobalKey<FormState>();
  final _emissionController = TextEditingController();

  @override
  void dispose() {
    /*
    In Flutter, the dispose() method is called automatically by the framework when a State 
    object is removed from the widget tree permanently. 
    This typically happens when the widget is no longer needed, for example, 
    when navigating away from a screen or when the parent widget rebuilds and 
    decides not to include the current widget in the new tree.
    */
    _emissionController.dispose();
    super.dispose();
  }

  void _addEmissionItem() {
    final newItem = EmissionItem(
      category: _emissioncategory!,
      type: _generalEmissionItem,
      emissionValue: _totalEmissions!,
      timestamp: DateTime.now(),
    );
    ref.read(emissionItemProvider.notifier).addEmissionItem(newItem);
    //print(_emissioncategory);
  }

  void _addEmissionItemVehicle() {
    print(_emissioncategory);
    final newItem = EmissionItem(
      category: _emissioncategory!,
      type: _carEmissionItem,
      emissionValue: _totalEmissions!,
      timestamp: DateTime.now(),
    );
    ref.read(emissionItemProvider.notifier).addEmissionItem(newItem);
  }

  void _saveForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addEmissionItem();
      // Save form data or process as needed
      print('Form saved successfully!');
      Navigator.of(context).popUntil((route) =>
          route.isFirst); //Disposes of previous screens before navigating.
      widget.updatePage(1);
    }
  }

  void _saveFormVehicle(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addEmissionItemVehicle();
      // Save form data or process as needed
      print('Form saved successfully!');
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.updatePage(1);
    }
  }

  double? _calculateEmissionsGeneral(double value) {
    double? emissionFactor;
    emissionFactor = allEmissionValues[_generalEmissionItem];
    //print(allEmissionValues[_generalEmissionItem]);
    //print(emissionFactor);
    if (emissionFactor != null) {
      // Process the emission factor with the provided value
      print('Emissions in kg/Co2');
      _totalEmissions = (value * emissionFactor);
      return _totalEmissions;
    }
    return null;
  }

  double? _calculateEmissionsVehicle(double value) {
    Map? fuelType;
    if (_fuelTypeIndex == 0) {
      fuelType = carTypePetrolValues;
    } else if (_fuelTypeIndex == 1) {
      fuelType = carTypeDieselValues;
    } else if (_fuelTypeIndex == 2) {
      fuelType = hybridElectricValues;
    } else if (_fuelTypeIndex == 3) {
      fuelType = batteryElectricValues;
    } else {
      return null;
    }
    var emissionFactor = fuelType[_carEmissionItem];
    //print(_carEmissionItem);
    //print('Emission Factor $emissionFactor');
    if (emissionFactor != null) {
      // Process the emission factor with the provided value
      //print('Emissions in kg/Co2');
      _totalEmissions = (value * emissionFactor);
      return _totalEmissions;
    }
    return null;
  }

  void _updateEmissions() {
    setState(() {
      double value = double.tryParse(_emissionController.text) ?? 0;
      _totalEmissions = _calculateEmissionsGeneral(value);
    });
  }

  void _updateVehicleEmissions() {
    setState(() {
      double value = double.tryParse(_emissionController.text) ?? 0;
      _totalEmissions = _calculateEmissionsVehicle(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carType == CarType.petrol) {
      _carFuelType = carTypePetrolDisplayNames;
    } else if (_carType == CarType.hybridElectric) {
      _carFuelType = hybridElectricDisplayNames;
    } else if (_carType == CarType.diesel) {
      _carFuelType = carTypeDieselDisplayNames;
    } else if (_carType == CarType.batteryElectric) {
      _carFuelType = batteryElectricDisplayNames;
    }

    String? validatePositiveNumber(String? value) {
      if (value == null ||
          value.isEmpty ||
          double.tryParse(value) == null ||
          double.parse(value) < 0) {
        return 'Please enter a valid positive number';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColours.bgOff,
        shadowColor: AppColours.accentDark,
        title: Text(
          'Add Carbon Emission',
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        backgroundColor: AppColours.bg,
      ),
      backgroundColor: AppColours.bg,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Carbon Emission Categories',
                    style: Theme.of(context).primaryTextTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...EmissionCategoriesDisplayName.keys.map(
                        (category) => SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(
                                () {
                                  if (_selectedIndex == category.index) {
                                    _selectedIndex =
                                        null; // Deselect if the same button is pressed again
                                  } else {
                                    _selectedIndex =
                                        category.index; // Select the new button
                                    _selectedEmissionItem = false;
                                    _generalEmissionIndex = null;
                                  }
                                  print(_selectedIndex);
                                },
                              );
                            },
                            label: Text(
                              EmissionCategoriesDisplayName[category]!,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            icon: Icon(
                              EmissionCategoriesIcon[category],
                              size: 20,
                              color: AppColours.accentDark,
                            ),
                            style: ButtonStyle(
                              backgroundColor: _selectedIndex == category.index
                                  ? const WidgetStatePropertyAll(
                                      AppColours.accentDarkPressed,
                                    )
                                  : const WidgetStatePropertyAll(
                                      AppColours.bg,
                                    ),
                              overlayColor: const WidgetStatePropertyAll(
                                AppColours.accentDarkPressed,
                              ),
                              side: const WidgetStatePropertyAll(
                                BorderSide(
                                    color: AppColours.accentDark, width: 2),
                              ),
                              elevation: WidgetStatePropertyAll(0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (_selectedIndex == 0) vehicleFuelSelection(context),
                  if (_selectedIndex == 0 && _carType != null)
                    vehicleEmissionSelection(context),
                  if (_selectedIndex == 0 &&
                      _carEmissionIndex != null &&
                      _fuelTypeIndex != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance Travelled',
                          style:
                              Theme.of(context).primaryTextTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                onChanged: (input) {
                                  _positive = validatePositiveNumber(input);
                                  setState(() {
                                    if (_positive == null) {
                                      _emissionScalar = double.parse(input);
                                      _calculateEmissionsVehicle(
                                          _emissionScalar!);
                                    }
                                    _emissioncategory =
                                        EmissionCategories.passengerVehicle;
                                  });
                                  //print(_emissionScalar);
                                  //print(_positive);
                                },
                                controller: _emissionController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                ),
                                validator: validatePositiveNumber,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text('Kilometres'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'This will add',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Text(
                                  _totalEmissions != null
                                      ? _totalEmissions!.toStringAsFixed(3)
                                      : 'No Emission Inputted',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Kilograms of CO2',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headlineSmall,
                                ),
                              ],
                            ),
                            Text(
                              'to your daily footprint',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveFormVehicle(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                AppColours.primaryAccent),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            elevation: WidgetStatePropertyAll(8),
                          ),
                          child: const Text('Add Emission Item'),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  if (_selectedIndex == 2)
                    EmissionSelection(
                      context,
                      busTypeDisplayNames,
                      Icons.train,
                      'Distance Travelled',
                      'Kilometres',
                      EmissionCategories.bus,
                    ),
                  if (_selectedIndex == 1)
                    EmissionSelection(
                      context,
                      foodTypeDisplayNames,
                      Linecons.food,
                      'Amount Consumed',
                      'Kilogram',
                      EmissionCategories.food,
                    ),
                  if (_selectedIndex == 4)
                    EmissionSelection(
                      context,
                      fuelTypeDisplayNames,
                      Icons.fireplace_outlined,
                      'Amount Burned',
                      'Tonnes',
                      EmissionCategories.fuel,
                    ),
                  if (_selectedIndex == 3)
                    EmissionSelection(
                      context,
                      trainTypeDisplayNames,
                      Icons.train,
                      'Distance Travelled',
                      'Kilometers',
                      EmissionCategories.train,
                    ),
                  if (_selectedIndex == 5)
                    EmissionSelection(
                      context,
                      householdApplianceDisplayNames,
                      Icons.house,
                      'Electricity Used',
                      'Minutes',
                      EmissionCategories.household,
                    ),
                  if (_selectedIndex == 6)
                    EmissionSelection(
                      context,
                      flightTypeDisplayNames,
                      Icons.airplanemode_active_rounded,
                      'Distance Travelled',
                      'Kilometers',
                      EmissionCategories.flight,
                    ),
                  if (_selectedEmissionItem == true && _selectedIndex != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _unitTitle!,
                          style:
                              Theme.of(context).primaryTextTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                onChanged: (input) {
                                  _positive = validatePositiveNumber(input);
                                  setState(() {
                                    if (_positive == null) {
                                      _emissionScalar = double.parse(input);
                                      _calculateEmissionsGeneral(
                                          _emissionScalar!);
                                    }
                                  });
                                  //print(_emissionScalar);
                                  //print(_positive);
                                },
                                controller: _emissionController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                ),
                                validator: validatePositiveNumber,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(_generalEmissionUnit!),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'This will add',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                Text(
                                  _totalEmissions != null
                                      ? _totalEmissions!.toStringAsFixed(3)
                                      : 'No Emission Inputted',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Kilograms of CO2',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headlineSmall,
                                ),
                              ],
                            ),
                            Text(
                              'to your daily footprint',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveForm(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                AppColours.primaryAccent),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            elevation: WidgetStatePropertyAll(8),
                          ),
                          child: const Text('Add Emission Item'),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column EmissionSelection(
    BuildContext context,
    Map displayNames,
    IconData icon,
    String unitTitle,
    String unit,
    EmissionCategories emissionCategory,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Emission Item',
          style: Theme.of(context).primaryTextTheme.headlineMedium,
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...displayNames.keys.map(
              (emissionitem) => SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_generalEmissionIndex == emissionitem.index) {
                        _generalEmissionIndex =
                            null; // Deselect if the same button is pressed again
                        _selectedEmissionItem = false;
                      } else {
                        _generalEmissionIndex =
                            emissionitem.index; // Select the new button
                        _selectedEmissionItem = true;
                      }
                      _generalEmissionItem = emissionitem;
                      print(_generalEmissionIndex);
                      print(_generalEmissionItem);
                      _unitTitle = unitTitle;
                      _generalEmissionUnit = unit;
                      _emissioncategory = emissionCategory;
                      _updateEmissions();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _generalEmissionIndex == emissionitem.index
                        ? const WidgetStatePropertyAll(
                            AppColours.accentDarkPressed,
                          )
                        : const WidgetStatePropertyAll(
                            AppColours.bg,
                          ),
                    overlayColor: const WidgetStatePropertyAll(
                      AppColours.accentDarkPressed,
                    ),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColours.accentDark, width: 2),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: AppColours.accentDark,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            displayNames[emissionitem],
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Column vehicleEmissionSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Emission Item',
          style: Theme.of(context).primaryTextTheme.headlineMedium,
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._carFuelType!.keys.map(
              (emissionitem) => SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_carEmissionIndex == emissionitem.index) {
                        _carEmissionIndex =
                            null; // Deselect if the same button is pressed again
                      } else {
                        _carEmissionIndex =
                            emissionitem.index; // Select the new button
                      }
                      _carEmissionItem = emissionitem;
                      print(_carEmissionIndex);
                      print(_carEmissionItem);
                      _updateVehicleEmissions();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _carEmissionIndex == emissionitem.index
                        ? const WidgetStatePropertyAll(
                            AppColours.accentDarkPressed,
                          )
                        : const WidgetStatePropertyAll(
                            AppColours.bg,
                          ),
                    overlayColor: const WidgetStatePropertyAll(
                      AppColours.accentDarkPressed,
                    ),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColours.accentDark, width: 2),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        FontAwesome.cab,
                        size: 20,
                        color: AppColours.accentDark,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            _carFuelType![emissionitem]!,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Column vehicleFuelSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Choose Vehicle Fuel Type',
          style: Theme.of(context).primaryTextTheme.headlineMedium,
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...carTypeDisplayNames.keys.map(
              (fuelType) => SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        if (_fuelTypeIndex == fuelType.index) {
                          _fuelTypeIndex =
                              null; // Deselect if the same button is pressed again
                        } else {
                          _fuelTypeIndex =
                              fuelType.index; // Select the new button
                        }
                        _carType = fuelType;
                        if (_fuelTypeIndex == null) {
                          _carType = null;
                        }
                        print(_fuelTypeIndex);
                        print(fuelType);
                        print(_carType);
                        _carEmissionIndex = null;
                        _carEmissionItem = null;
                        _updateVehicleEmissions();
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: _fuelTypeIndex == fuelType.index
                        ? const WidgetStatePropertyAll(
                            AppColours.accentDarkPressed,
                          )
                        : const WidgetStatePropertyAll(
                            AppColours.bg,
                          ),
                    overlayColor: const WidgetStatePropertyAll(
                      AppColours.accentDarkPressed,
                    ),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColours.accentDark, width: 2),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        FontAwesome.cab,
                        size: 20,
                        color: AppColours.accentDark,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            carTypeDisplayNames[fuelType]!,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

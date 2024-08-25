import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';

enum EmissionCategories { 
  passengerVehicle,
  food,
  bus,
  train,
  fuel,
  household,
  flight
}

Map<EmissionCategories, String> EmissionCategoriesDisplayName = {
  EmissionCategories.passengerVehicle: 'Vehicle',
  EmissionCategories.bus: 'Bus',
  EmissionCategories.train: 'Train',
  EmissionCategories.flight: 'Airplane',
  EmissionCategories.food: 'Food',
  EmissionCategories.fuel: 'Fuel',
  EmissionCategories.household: 'Household',
};

//Using https://fluttericon.com/
//Download individual icon to speed up app and reduce size!!
Map<EmissionCategories, IconData> EmissionCategoriesIcon = {
  EmissionCategories.passengerVehicle: FontAwesome.cab,
  EmissionCategories.bus: Icons.bus_alert,
  EmissionCategories.food: Linecons.food,
  EmissionCategories.fuel: Elusive.fire,
  EmissionCategories.household: Icons.house,
  EmissionCategories.train: Icons.train,
  EmissionCategories.flight: Icons.airplanemode_active_rounded,
};

Map<EmissionCategories, String> CategoryDescriptions = {
  EmissionCategories.passengerVehicle:
      'Vehicle travel, especially using fossil fuel-powered cars and trucks, is a major source of carbon emissions for individuals. The combustion of gasoline and diesel fuels releases CO2 and other pollutants into the atmosphere, contributing to climate change and air pollution. To lessen the carbon footprint from vehicle travel, opt for fuel-efficient vehicles or consider electric vehicles (EVs) powered by renewable energy sources. Additionally, carpooling, using public transportation, biking, or walking whenever feasible can significantly reduce emissions associated with personal vehicle use.',
  EmissionCategories.flight:
      'Flying abroad significantly contributes to your carbon footprint due to the emissions released by aircraft engines. Air travel emits large amounts of greenhouse gases, primarily carbon dioxide (CO2), but also nitrogen oxides (NOx), water vapor, and particulate matter. The emissions from a single long-haul flight can surpass those of several months of driving or household energy use. To reduce the environmental impact of flying abroad, consider alternatives like video conferencing for business meetings, choosing direct flights when possible to reduce fuel consumption, and supporting airlines that prioritize sustainability practices.',
  EmissionCategories.food:
      'Your diet significantly influences your carbon footprint and offers substantial potential for reduction. Animal agriculture, particularly meat and dairy production, contributes significantly to greenhouse gas emissions through methane production, land use, and energy-intensive feed production. Shifting towards a plant-based diet, such as vegetarian or vegan options, can substantially reduce your environmental impact. Plant-based diets require fewer resources and produce fewer emissions compared to diets high in animal products. Additionally, supporting sustainable farming practices and choosing locally sourced, seasonal foods can further reduce the carbon footprint of your diet. By making informed choices about what you eat, you can play a crucial role in mitigating climate change and promoting environmental sustainability.',
  EmissionCategories.fuel:
      'Alternative heating methods, such as burning wood or biomass, can significantly impact your carbon footprint. While wood burning can provide renewable heat, it releases carbon dioxide (CO2), methane (CH4), and other pollutants into the atmosphere, contributing to local air pollution and climate change. The sustainability of wood burning depends on responsible forestry practices and efficient combustion technologies. To minimize the environmental impact of alternative heating, consider using certified sustainable wood sources, properly maintaining your heating equipment to ensure efficient burning with minimal emissions, and exploring cleaner alternatives like pellet stoves or modern wood-burning stoves that comply with emissions standards. Additionally, reducing overall heating demand through improved insulation and energy-efficient home design can help mitigate the environmental impact of alternative heating methods while ensuring a comfortable living environment.',
  EmissionCategories.household:
      'Household electricity consumption is another significant contributor to carbon emissions, especially if the electricity is generated from fossil fuels such as coal, natural gas, and oil. These fuels release CO2 and other greenhouse gases during combustion. To reduce your household electricity emissions, consider switching to renewable energy sources such as solar or wind power. Energy-efficient appliances, LED lighting, and smart home technologies can also help minimize electricity consumption and lower your carbon footprint.',
};

Map<EmissionCategories, String> CategoryUrls = {
  EmissionCategories.passengerVehicle: 'https://www.bbc.com/future/article/20200317-climate-change-cut-carbon-emissions-from-your-commute',
  EmissionCategories.flight: 'https://www.bbc.com/future/article/20200218-climate-change-how-to-cut-your-carbon-emissions-when-flying',
  EmissionCategories.fuel: 'https://www.ucsusa.org/resources/car-emissions-global-warming',
  EmissionCategories.food:'https://www.bbc.com/future/article/20220429-the-climate-benefits-of-veganism-and-vegetarianism',
  EmissionCategories.household: 'https://www.bbc.com/future/article/20201204-climate-change-how-chemicals-in-your-fridge-warm-the-planet',
};

import 'package:carbon_tracker/providers/emission_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Function to generate chart data
List<FlSpot> generateChartData(List<EmissionItem> emissionItems) {
  Map<String, double> dailyEmissions = {};
  DateTime now = DateTime.now();

  // Initialize daily emissions for the past 7 days
  for (int i = 0; i < 7; i++) {
    DateTime date = now.subtract(Duration(days: i));
    String dateKey = DateFormat('yyyy-MM-dd').format(date);
    dailyEmissions[dateKey] = 0.0;
  }

  // Aggregate emissions by day
  for (var item in emissionItems) {
    String dateKey = DateFormat('yyyy-MM-dd').format(item.timestamp);
    if (dailyEmissions.containsKey(dateKey)) {
      dailyEmissions[dateKey] =
          (dailyEmissions[dateKey] ?? 0) + item.emissionValue;
    }
  }

  // Generate chart data
  List<FlSpot> chartData = [];
  for (int i = 0; i < 7; i++) {
    DateTime date = now.subtract(Duration(days: i));
    String dateKey = DateFormat('yyyy-MM-dd').format(date);
    double emission = dailyEmissions[dateKey] ?? 0.0;
    chartData.add(FlSpot((6 - i).toDouble(), emission));
  }

  return chartData;
}

List<FlSpot> generateAverageEmissionsData(double averageEmissions) {
  List<FlSpot> averageData = [];
  for (int i = 0; i < 7; i++) {
    averageData.add(FlSpot(i.toDouble(), averageEmissions));
  }
  return averageData;
}

class EmissionsChart extends StatelessWidget {
  final List<EmissionItem> emissionItems;
  final double totalEstimatedEmissions;
  final Key key;

  EmissionsChart({
    required this.emissionItems,
    required this.totalEstimatedEmissions,
    required this.key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('Widget Test');
    List<FlSpot> chartData = generateChartData(emissionItems);
    List<FlSpot> averageData =
        generateAverageEmissionsData(totalEstimatedEmissions);

    final maxDataValue = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) != 0
        ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b)
        : 5.0; // Default max value if chartData is empty or all values are zero

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toStringAsFixed(1)} kg');
                  },
                  interval: totalEstimatedEmissions >
                          maxDataValue
                              .ceilToDouble()
                      ? totalEstimatedEmissions / 3
                      : maxDataValue
                              .ceilToDouble() /
                          5,
                  reservedSize: 60,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    DateTime date = DateTime.now().subtract(
                      Duration(
                        days: (6 - value.toInt()),
                      ),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('dd-MM').format(date),
                      ),
                    );
                  },
                  interval: 1,
                  reservedSize: 40,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black, width: 1),
            ),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: totalEstimatedEmissions >
                    (maxDataValue +
                            0)
                        .ceilToDouble()
                ? totalEstimatedEmissions
                : (maxDataValue +
                        0)
                    .ceilToDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: chartData,
                isCurved: false,
                color: Colors.green.shade700,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: averageData,
                isCurved: true,
                color: Colors.red,
                preventCurveOverShooting: true,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';

class RoiPaybackCalculator extends StatelessWidget {
  const RoiPaybackCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolarCalculatorController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ROI & Payback Period',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Calculate your return on investment and payback period',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Monthly Savings
          Card(
            color: AppColors.solarGreenLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Savings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      '₹${NumberFormat('#,##,###').format(controller.monthlySavings.value)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solarGreen,
                      ),
                    ),
                  ),
                  const Text('per month on electricity bills'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payback Period
          Card(
            color: AppColors.solarBlueLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payback Period',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      '${controller.paybackPeriod.value.toStringAsFixed(1)} years',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solarBlue,
                      ),
                    ),
                  ),
                  const Text('to recover your investment'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 25-Year Savings
          Card(
            color: AppColors.solarPurpleLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '25-Year Savings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      '₹${NumberFormat('#,##,###').format(controller.twentyFiveYearSavings.value)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solarPurple,
                      ),
                    ),
                  ),
                  const Text('total savings over 25 years'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ROI Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Savings Projection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Obx(
                      () => LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _generateSavingsData(controller),
                              isCurved: true,
                              color: AppColors.solarOrange,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSavingsData(SolarCalculatorController controller) {
    List<FlSpot> spots = [];
    double netCost = controller.netProjectCost;

    for (int year = 0; year <= 25; year++) {
      double cumulativeSavings =
          (controller.monthlySavings.value * 12 * year) - netCost;
      spots.add(FlSpot(year.toDouble(), cumulativeSavings));
    }

    return spots;
  }
}

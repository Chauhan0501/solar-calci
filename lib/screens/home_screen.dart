import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';
import 'dart:math';
import 'dart:ui';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolarCalculatorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ Solar Calculator'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            /*
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.solar_power, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Solar System Calculator',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calculate your perfect solar system size and savings',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
*/
            const SizedBox(height: 24),

            // System Size Estimator Section
            _buildSystemSizeSection(controller),
            const SizedBox(height: 24),

            // Results Section (shown after calculation)
            Obx(
              () => controller.calculatedSystemSize.value > 0
                  ? _buildResultsSection(controller)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSizeSection(SolarCalculatorController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Your Solar System Size',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your electricity details to get started',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Bill Type Selection
            // const Text(
            //   'Bill Type',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            // Obx(
            //   () => Row(
            //     children: [
            //       Expanded(
            //         child: RadioListTile<bool>(
            //           title: const Text('Daily Bill'),
            //           value: false,
            //           groupValue: controller.isMonthlyBill.value,
            //           onChanged: (value) {
            //             controller.updateBillType(value!);
            //           },
            //         ),
            //       ),
            //       Expanded(
            //         child: RadioListTile<bool>(
            //           title: const Text('Monthly Bill'),
            //           value: true,
            //           groupValue: controller.isMonthlyBill.value,
            //           onChanged: (value) {
            //             controller.updateBillType(value!);
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),

            // Electricity Rate
            const Text(
              'Electricity Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      '₹${controller.electricityRate.value.toStringAsFixed(1)} per unit',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: controller.electricityRate.value,
                      min: 5,
                      max: 12,
                      divisions: 14,
                      onChanged: (value) {
                        controller.updateElectricityRate(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Electricity Bill Input
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isMonthlyBill.value
                        ? 'Monthly Electricity Bill (₹)'
                        : 'Daily Electricity Bill (₹)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: controller.isMonthlyBill.value
                          ? 'Enter monthly electricity bill in rupees'
                          : 'Enter daily electricity bill in rupees',
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    onChanged: (value) {
                      if (controller.isMonthlyBill.value) {
                        controller.updateMonthlyUsage(value);
                      } else {
                        controller.updateDailyUsage(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appliance Count Inputs
            const Text(
              'Number of Appliances',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Column(
                children: [
                  _buildApplianceInput(
                    'Fans',
                    controller.numberOfFans.value,
                    (value) => controller.updateFans(value),
                    Icons.air,
                  ),
                  const SizedBox(height: 12),
                  _buildApplianceInput(
                    'LED Lights',
                    controller.numberOfLights.value,
                    (value) => controller.updateLights(value),
                    Icons.lightbulb,
                  ),
                  const SizedBox(height: 12),
                  _buildApplianceInput(
                    'Air Conditioners',
                    controller.numberOfACs.value,
                    (value) => controller.updateACs(value),
                    Icons.ac_unit,
                  ),
                  const SizedBox(height: 12),
                  _buildApplianceInput(
                    'Other Appliances',
                    controller.numberOfAppliances.value,
                    (value) => controller.updateAppliances(value),
                    Icons.devices,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(SolarCalculatorController controller) {
    return Column(
      children: [
        // System Size Result
        Card(
          color: AppColors.solarOrangeLight,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Recommended Solar System',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.solar_power,
                      size: 48,
                      color: AppColors.solarOrange,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            '${controller.calculatedSystemSize.value.toStringAsFixed(2)} kW',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.solarOrange,
                            ),
                          ),
                        ),
                        const Text(
                          'Solar System',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    'Estimated Project Cost: ₹${NumberFormat('#,##,###').format(controller.projectCost.value)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Subsidy & EMI Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subsidy & EMI Options',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Subsidy Amount: ₹${NumberFormat('#,##,###').format(controller.subsidyAmount.value)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: controller.subsidyAmount.value,
                              min: 0,
                              max: 200000,
                              divisions: 200,
                              onChanged: (value) {
                                controller.updateSubsidyAmount(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   'Subsidy Amount: ₹${NumberFormat('#,##,###').format(controller.totalSubsidy)}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.solarGreen,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Interest Rate: ${controller.interestRate.value.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: controller.interestRate.value,
                              min: 5,
                              max: 15,
                              divisions: 20,
                              onChanged: (value) {
                                controller.updateInterestRate(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   'Monthly EMI: ₹${NumberFormat('#,##,###').format(controller.emiAmount)}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.solarBlue,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Text(
                          'EMI Tenure: ${controller.emiTenure.value.toInt()} years',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: controller.emiTenure.value,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (value) {
                            controller.updateEmiTenure(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => _buildSummaryRow(
                    'Total Project Cost',
                    '₹${NumberFormat('#,##,###').format(controller.projectCost.value)}',
                  ),
                ),
                Obx(
                  () => _buildSummaryRow(
                    'Subsidy Amount',
                    '₹${NumberFormat('#,##,###').format(controller.totalSubsidy)}',
                  ),
                ),
                Obx(
                  () => _buildSummaryRow(
                    'Net Project Cost',
                    '₹${NumberFormat('#,##,###').format(controller.netProjectCost)}',
                  ),
                ),
                Obx(
                  () => _buildSummaryRow(
                    'Monthly EMI',
                    '₹${NumberFormat('#,##,###').format(controller.emiAmount)}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ROI & Savings Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Savings & ROI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: AppColors.solarGreenLight,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Monthly Savings',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => Text(
                                  '₹${NumberFormat('#,##,###').format(controller.monthlySavings.value)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.solarGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: AppColors.solarBlueLight,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Payback Period',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => Text(
                                  '${controller.paybackPeriod.value.toStringAsFixed(1)} years',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.solarBlue,
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
                const SizedBox(height: 16),
                Obx(
                  () => _buildSummaryRow(
                    '25-Year Total Savings',
                    '₹${NumberFormat('#,##,###').format(controller.twentyFiveYearSavings.value)}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplianceInput(
    String label,
    int value,
    Function(int) onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.solarOrange, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Row(
          children: [
            IconButton(
              onPressed: () => onChanged(value > 0 ? value - 1 : 0),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

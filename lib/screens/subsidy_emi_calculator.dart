import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';

class SubsidyEmiCalculator extends StatelessWidget {
  const SubsidyEmiCalculator({super.key});

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
                    'Subsidy & EMI Calculator',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Calculate government subsidy and EMI options',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Project Cost Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Cost',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      '₹${NumberFormat('#,##,###').format(controller.projectCost.value)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solarOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Subsidy Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Government Subsidy',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Subsidy Percentage: ${controller.subsidyPercentage.value.toInt()}%',
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.subsidyPercentage.value,
                            min: 0,
                            max: 50,
                            divisions: 10,
                            onChanged: (value) {
                              controller.updateSubsidyPercentage(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      'Subsidy Amount: ₹${NumberFormat('#,##,###').format(controller.totalSubsidy)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // EMI Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EMI Calculator',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tenure: ${controller.emiTenure.value.toInt()} years',
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

                  const SizedBox(height: 8),

                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Interest Rate: ${controller.interestRate.value.toStringAsFixed(1)}%',
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
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Card(
            color: AppColors.solarGreenLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EMI Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

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
                  Obx(
                    () => _buildSummaryRow(
                      'Total Interest',
                      '₹${NumberFormat('#,##,###').format((controller.emiAmount * controller.emiTenure.value * 12) - controller.netProjectCost)}',
                    ),
                  ),
                  Obx(
                    () => _buildSummaryRow(
                      'Total Amount',
                      '₹${NumberFormat('#,##,###').format(controller.emiAmount * controller.emiTenure.value * 12)}',
                    ),
                  ),
                  _buildSummaryRow('Max Tenure Available', '5 years'),
                ],
              ),
            ),
          ),
        ],
      ),
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

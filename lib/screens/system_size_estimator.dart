import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';

class SystemSizeEstimator extends StatelessWidget {
  const SystemSizeEstimator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolarCalculatorController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            ignoring: controller.hasCalculated.value,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Size Estimator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Calculate solar system size based on your electricity usage',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Calculate / Reset Buttons
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.hasCalculated.value
                        ? null
                        : () {
                            final bool hasBillInput =
                                (controller.monthlyUsageRupees.value > 0) ||
                                (controller.dailyUsageRupees.value > 0);
                            final bool hasAnyAppliance =
                                controller.numberOfTubelights.value > 0 ||
                                controller.numberOfLights.value > 0 ||
                                controller.numberOfFans.value > 0 ||
                                controller.numberOfWallFans.value > 0 ||
                                controller.numberOfAirCoolers.value > 0 ||
                                controller.numberOfTVs.value > 0 ||
                                controller.numberOfRefrigerators.value > 0 ||
                                controller.numberOfAppliances.value > 0 ||
                                controller.numberOfWaterPurifiers.value > 0 ||
                                controller.numberOfSurfacePumps.value > 0 ||
                                controller.numberOfSubmersiblePumps.value > 0 ||
                                controller.numberOfACs.value > 0;

                            if (!hasBillInput && !hasAnyAppliance) {
                              Get.snackbar(
                                'Missing inputs',
                                'Please enter your electricity bill or select at least one appliance.',
                                backgroundColor: AppColors.error,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            controller.calculateSystemSize();
                          },
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.hasCalculated.value
                        ? () {
                            controller.resetCalculation();
                          }
                        : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bill Type Selection
          /*
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Daily Bill'),
                            value: false,
                            groupValue: controller.isMonthlyBill.value,
                            onChanged: (value) {
                              controller.updateBillType(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Monthly Bill'),
                            value: true,
                            groupValue: controller.isMonthlyBill.value,
                            onChanged: (value) {
                              controller.updateBillType(value!);
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
*/
          const SizedBox(height: 16),

          // Electricity Rate
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Electricity Bill Input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.isMonthlyBill.value
                          ? 'Monthly Electricity Bill (₹)'
                          : 'Daily Electricity Bill (₹)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => controller.hasCalculated.value
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.background,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    controller.isMonthlyBill.value
                                        ? 'Monthly Bill: ₹${controller.monthlyUsageRupees.value.toStringAsFixed(0)}'
                                        : 'Daily Bill: ₹${controller.dailyUsageRupees.value.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: controller.isMonthlyBill.value
                                  ? 'Enter monthly electricity bill in rupees'
                                  : 'Enter daily electricity bill in rupees',
                            ),
                            onChanged: (value) {
                              if (controller.isMonthlyBill.value) {
                                controller.updateMonthlyUsage(value);
                              } else {
                                controller.updateDailyUsage(value);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Appliance Count Inputs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Number of Appliances',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => _buildApplianceInput(
                      'Fans',
                      controller.numberOfFans.value,
                      (value) => controller.updateFans(value),
                      Icons.air,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => _buildApplianceInput(
                      'LED Lights',
                      controller.numberOfLights.value,
                      (value) => controller.updateLights(value),
                      Icons.lightbulb,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => _buildApplianceInput(
                      'Air Conditioners',
                      controller.numberOfACs.value,
                      (value) => controller.updateACs(value),
                      Icons.ac_unit,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => _buildApplianceInput(
                      'Other Appliances',
                      controller.numberOfAppliances.value,
                      (value) => controller.updateAppliances(value),
                      Icons.devices,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Obx(
            () => controller.calculatedSystemSize.value > 0
                ? Card(
                    color: AppColors.solarOrangeLight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recommended System Size',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
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
                                  Text(
                                    '${controller.calculatedSystemSize.value.toStringAsFixed(2)} kW',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarOrange,
                                    ),
                                  ),
                                  Text(
                                    'Solar System',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Estimated Project Cost: ₹${NumberFormat('#,##,###').format(controller.projectCost.value)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
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
        Icon(icon, color: AppColors.solarOrange),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
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
}

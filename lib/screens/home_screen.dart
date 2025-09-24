import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolarCalculatorController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ Solar Calculator'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSystemSizeSection(controller, isMobile),
            const SizedBox(height: 16),
            Obx(
              () => controller.calculatedSystemSize.value > 0
                  ? _buildResultsSection(controller, isMobile)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSizeSection(
    SolarCalculatorController controller,
    bool isMobile,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => controller.hasCalculated.value
                        ? const SizedBox.shrink()
                        : const Text(
                            'System Size Estimator',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                Obx(
                  () =>
                      controller.showCalculator.value &&
                          !controller.hasCalculated.value
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              controller.calculateSystemSize();
                              },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3), // shadow position
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "Calculate",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Electricity Rate (visible only while filling)
            Obx(
              () =>
                  controller.showCalculator.value &&
                      !controller.hasCalculated.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Electricity Rate per Unit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
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
                                min: 7,
                                max: 15,
                                divisions: 20,
                                onChanged: (value) {
                                  controller.updateElectricityRate(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Bill Input Section
            Obx(
              () => controller.hasCalculated.value
                  ? const SizedBox.shrink()
                  : const Text(
                      'Your Electricity Bill',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            // const SizedBox(height: 8),
            //
            // // Bill Type Toggle
            // Obx(
            //   () => Row(
            //     children: [
            //       Expanded(
            //         child: ChoiceChip(
            //           label: const Text('Monthly Bill'),
            //           selected: controller.isMonthlyBill.value,
            //           onSelected: (selected) {
            //             if (selected) controller.updateBillType(true);
            //           },
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: ChoiceChip(
            //           label: const Text('Daily Bill'),
            //           selected: !controller.isMonthlyBill.value,
            //           onSelected: (selected) {
            //             if (selected) controller.updateBillType(false);
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            // Bill Amount Input (visible only while filling: showCalculator && !hasCalculated)
            Obx(
              () =>
                  controller.showCalculator.value &&
                      !controller.hasCalculated.value
                  ? TextField(
                      decoration: InputDecoration(
                        labelText: controller.isMonthlyBill.value
                            ? 'Monthly Bill Amount (₹)'
                            : 'Daily Bill Amount (₹)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (controller.isMonthlyBill.value) {
                          controller.updateMonthlyUsage(value);
                        } else {
                          controller.updateDailyUsage(value);
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Appliance Count Inputs (visible only while filling)
            Obx(
              () =>
                  controller.showCalculator.value &&
                      !controller.hasCalculated.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Number of Appliances',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Row 1: Lighting
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Tubelights (18W)',
                              controller.numberOfTubelights.value,
                              (value) => controller.updateTubelights(value),
                              Icons.lightbulb_outline,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'LED Bulbs (9W)',
                              controller.numberOfLights.value,
                              (value) => controller.updateLights(value),
                              Icons.lightbulb,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Tubelights (18W)',
                                    controller.numberOfTubelights.value,
                                    (value) =>
                                        controller.updateTubelights(value),
                                    Icons.lightbulb_outline,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'LED Bulbs (9W)',
                                    controller.numberOfLights.value,
                                    (value) => controller.updateLights(value),
                                    Icons.lightbulb,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Row 2: Fans
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Ceiling Fans (75W)',
                              controller.numberOfFans.value,
                              (value) => controller.updateFans(value),
                              Icons.air,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Wall Fans (55W)',
                              controller.numberOfWallFans.value,
                              (value) => controller.updateWallFans(value),
                              Icons.air,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Ceiling Fans (75W)',
                                    controller.numberOfFans.value,
                                    (value) => controller.updateFans(value),
                                    Icons.air,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Wall Fans (55W)',
                                    controller.numberOfWallFans.value,
                                    (value) => controller.updateWallFans(value),
                                    Icons.air,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Row 3: Cooling
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Air Coolers (150W)',
                              controller.numberOfAirCoolers.value,
                              (value) => controller.updateAirCoolers(value),
                              Icons.ac_unit,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'ACs (1.5T, 1500W)',
                              controller.numberOfACs.value,
                              (value) => controller.updateACs(value),
                              Icons.ac_unit,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Air Coolers (150W)',
                                    controller.numberOfAirCoolers.value,
                                    (value) =>
                                        controller.updateAirCoolers(value),
                                    Icons.ac_unit,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'ACs (1.5T, 1500W)',
                                    controller.numberOfACs.value,
                                    (value) => controller.updateACs(value),
                                    Icons.ac_unit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Row 4: Entertainment & Kitchen
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'TVs (32", 60W)',
                              controller.numberOfTVs.value,
                              (value) => controller.updateTVs(value),
                              Icons.tv,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Refrigerators (180W)',
                              controller.numberOfRefrigerators.value,
                              (value) => controller.updateRefrigerators(value),
                              Icons.kitchen,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'TVs (32", 60W)',
                                    controller.numberOfTVs.value,
                                    (value) => controller.updateTVs(value),
                                    Icons.tv,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Refrigerators (180W)',
                                    controller.numberOfRefrigerators.value,
                                    (value) =>
                                        controller.updateRefrigerators(value),
                                    Icons.kitchen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Row 5: Laundry & Water
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Washing Machines (500W)',
                              controller.numberOfAppliances.value,
                              (value) => controller.updateAppliances(value),
                              Icons.local_laundry_service,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Water Purifiers (25W)',
                              controller.numberOfWaterPurifiers.value,
                              (value) => controller.updateWaterPurifiers(value),
                              Icons.water_drop,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Washing Machines (500W)',
                                    controller.numberOfAppliances.value,
                                    (value) =>
                                        controller.updateAppliances(value),
                                    Icons.local_laundry_service,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Water Purifiers (25W)',
                                    controller.numberOfWaterPurifiers.value,
                                    (value) =>
                                        controller.updateWaterPurifiers(value),
                                    Icons.water_drop,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Row 6: Pumps
                        if (isMobile) ...[
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Surface Pumps (750W)',
                              controller.numberOfSurfacePumps.value,
                              (value) => controller.updateSurfacePumps(value),
                              Icons.water,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: controller.hasCalculated.value,
                            child: _buildApplianceInput(
                              'Submersible Pumps (1500W)',
                              controller.numberOfSubmersiblePumps.value,
                              (value) =>
                                  controller.updateSubmersiblePumps(value),
                              Icons.water,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Surface Pumps (750W)',
                                    controller.numberOfSurfacePumps.value,
                                    (value) =>
                                        controller.updateSurfacePumps(value),
                                    Icons.water,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.hasCalculated.value,
                                  child: _buildApplianceInput(
                                    'Submersible Pumps (1500W)',
                                    controller.numberOfSubmersiblePumps.value,
                                    (value) => controller
                                        .updateSubmersiblePumps(value),
                                    Icons.water,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),
            // Single entry button area controlling flow
            Obx(
              () => controller.hasCalculated.value
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          controller.resetCalculation();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(
    SolarCalculatorController controller,
    bool isMobile,
  ) {
    return Column(
      children: [
        // System Size Result Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended System Size',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.solarGreenLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.solarGreen),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.solar_power,
                          size: isMobile ? 32 : 48,
                          color: AppColors.solarGreen,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Solar System Size',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${controller.calculatedSystemSize.value.toStringAsFixed(2)} kW',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.solarGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
            padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                      const Text(
                        'Subsidy Eligibility (PM Surya Ghar Yojana)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSubsidyTierInfo(controller),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: controller.calculatedSystemSize.value >= 1.0
                              ? AppColors.solarGreenLight
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: controller.calculatedSystemSize.value >= 1.0
                                ? AppColors.solarGreen
                                : AppColors.divider,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              controller.calculatedSystemSize.value >= 1.0
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              color:
                                  controller.calculatedSystemSize.value >= 1.0
                                  ? AppColors.solarGreen
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.calculatedSystemSize.value >= 1.0
                                        ? 'Subsidy Available'
                                        : 'Subsidy Not Available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller
                                                  .calculatedSystemSize
                                                  .value >=
                                              1.0
                                          ? AppColors.solarGreen
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.calculatedSystemSize.value >= 1.0
                                        ? '₹${NumberFormat('#,##,###').format(controller.totalSubsidy)}'
                                        : 'Minimum 1 kW system required',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller
                                                  .calculatedSystemSize
                                                  .value >=
                                              1.0
                                          ? AppColors.solarGreen
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // EMI Options
                const Text(
                  'EMI Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // EMI Tenure
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      const SizedBox(height: 16),

                      // Interest Rate
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
                              min: 7,
                              max: 15,
                              divisions: 16,
                              onChanged: (value) {
                                controller.updateInterestRate(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.solarBlueLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.solarBlue),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance,
                              color: AppColors.solarBlue,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Monthly EMI',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${NumberFormat('#,##,###').format(controller.emiAmount)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cost Summary
                const Text(
                  'Cost Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Savings & ROI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Savings Cards
                if (isMobile) ...[
                  Obx(
                    () => Card(
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
                            Text(
                              '₹${NumberFormat('#,##,###').format(controller.monthlySavings.value)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.solarGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Card(
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
                            Text(
                              '${controller.paybackPeriod.value.toStringAsFixed(1)} years',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.solarBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Card(
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
                                  Text(
                                    '₹${NumberFormat('#,##,###').format(controller.monthlySavings.value)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => Card(
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
                                  Text(
                                    '${controller.paybackPeriod.value.toStringAsFixed(1)} years',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // 25-Year Savings
                Obx(
                  () => _buildSummaryRow(
                    '25-Year Total Savings',
                    '₹${NumberFormat('#,##,###').format(controller.twentyFiveYearSavings.value)}',
                  ),
                ),
                const SizedBox(height: 16),

                // Environmental Impact Section
                const Text(
                  'Environmental Impact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Environmental Cards
                if (isMobile) ...[
                  Obx(
                    () => Card(
                      color: AppColors.solarGreenLight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'CO₂ Mitigated',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${NumberFormat('#,##,###').format(controller.co2Mitigated.value)} kg/year',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.solarGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Card(
                      color: AppColors.solarGreenLight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Trees Planted',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${NumberFormat('#,##,###').format(controller.treesPlanted.value)} trees',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.solarGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Card(
                            color: AppColors.solarGreenLight,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    'CO₂ Mitigated',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${NumberFormat('#,##,###').format(controller.co2Mitigated.value)} kg/year',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => Card(
                            color: AppColors.solarGreenLight,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Trees Planted',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${NumberFormat('#,##,###').format(controller.treesPlanted.value)} trees',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solarGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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

  Widget _buildSubsidyTierInfo(SolarCalculatorController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subsidy Tiers:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTierItem('1 kW', '₹45,000', AppColors.solarBlue),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierItem('2 kW', '₹90,000', AppColors.solarGreen),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierItem(
                  '3+ kW',
                  '₹1,08,000',
                  AppColors.solarOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierItem(String size, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            size,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(amount, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}

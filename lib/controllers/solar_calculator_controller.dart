import 'package:get/get.dart';
import 'dart:math';
import '../models/appliance_load.dart';
import '../constants/app_colors.dart';

class SolarCalculatorController extends GetxController {
  // System Size Estimator
  RxDouble dailyUsageRupees = 0.0.obs;
  RxDouble monthlyUsageRupees = 0.0.obs;
  RxBool isMonthlyBill = true.obs; // true for monthly, false for daily
  RxDouble electricityRate = 7.0.obs; // rupees per unit
  // Appliance counts
  RxInt numberOfFans = 0.obs;
  RxInt numberOfLights = 0.obs;
  RxInt numberOfACs = 0.obs;
  RxInt numberOfAppliances = 0.obs;
  RxInt numberOfTubelights = 0.obs;
  RxInt numberOfWallFans = 0.obs;
  RxInt numberOfAirCoolers = 0.obs;
  RxInt numberOfTVs = 0.obs;
  RxInt numberOfRefrigerators = 0.obs;
  RxInt numberOfWaterPurifiers = 0.obs;
  RxInt numberOfSurfacePumps = 0.obs;
  RxInt numberOfSubmersiblePumps = 0.obs;
  RxDouble calculatedSystemSize = 0.0.obs;

  // Subsidy & EMI
  RxDouble projectCost = 0.0.obs;
  RxDouble subsidyAmount = 108000.0.obs; // Default ₹1,08,000
  RxDouble emiTenure = 2.0.obs; // Default to 2 years, max 5 years
  RxDouble interestRate = 7.0.obs;

  // ROI & Payback
  RxDouble monthlySavings = 0.0.obs;
  RxDouble paybackPeriod = 0.0.obs;
  RxDouble twentyFiveYearSavings = 0.0.obs;

  // Environmental Impact
  RxDouble co2Mitigated = 0.0.obs; // CO2 mitigated in kg per year
  RxDouble treesPlanted = 0.0.obs; // Equivalent trees planted

  // Load Chart Data
  RxList<ApplianceLoad> applianceLoads = <ApplianceLoad>[].obs;

  @override
  void onInit() {
    super.onInit();
    updateApplianceLoads();
  }

  void calculateSystemSize() {
    // Calculate based on daily usage in rupees
    double dailyUsageKWh;
    if (isMonthlyBill.value) {
      // Convert monthly bill to daily usage
      dailyUsageKWh = (monthlyUsageRupees.value / 30) / electricityRate.value;
    } else {
      // Direct daily usage
      dailyUsageKWh = dailyUsageRupees.value / electricityRate.value;
    }

    // Calculate based on all appliances
    double applianceLoad =
        (numberOfTubelights.value * 18) + // Tubelights: 18W
        (numberOfLights.value * 9) + // LED Bulbs: 9W
        (numberOfFans.value * 75) + // Ceiling Fans: 75W
        (numberOfWallFans.value * 55) + // Wall Fans: 55W
        (numberOfAirCoolers.value * 150) + // Air Coolers: 150W
        (numberOfTVs.value * 60) + // TVs: 60W
        (numberOfRefrigerators.value * 180) + // Refrigerators: 180W
        (numberOfAppliances.value * 500) + // Washing Machines: 500W
        (numberOfWaterPurifiers.value * 25) + // Water Purifiers: 25W
        (numberOfSurfacePumps.value * 750) + // Surface Pumps: 750W
        (numberOfSubmersiblePumps.value * 1500) + // Submersible Pumps: 1500W
        (numberOfACs.value * 1500); // Air Conditioners: 1500W

    // Convert to daily kWh (assuming 6 hours of usage)
    double applianceDailyKWh = (applianceLoad * 6) / 1000;

    // Use the higher of the two calculations
    double requiredDailyKWh = dailyUsageKWh > applianceDailyKWh
        ? dailyUsageKWh
        : applianceDailyKWh;

    // Solar system size (kW) = Daily kWh / (4.5 hours of peak sun * 0.75 efficiency)
    calculatedSystemSize.value = requiredDailyKWh / (4.5 * 0.75);

    // Calculate project cost based on tiered pricing
    if (calculatedSystemSize.value <= 3.0) {
      // Up to 3 kW: ₹60 per watt
      projectCost.value = (calculatedSystemSize.value * 1000 * 60)
          .roundToDouble();
    } else {
      // Above 3 kW: ₹55 per watt
      projectCost.value = (calculatedSystemSize.value * 1000 * 55)
          .roundToDouble();
    }

    // Calculate monthly savings
    if (dailyUsageKWh > 0) {
      // If bill data is provided, use it
      if (isMonthlyBill.value) {
        monthlySavings.value = monthlyUsageRupees.value;
      } else {
        monthlySavings.value = dailyUsageRupees.value * 30;
      }
    } else {
      // If no bill data but appliances are added, calculate savings based on solar generation
      // 1 kW solar system generates ~4.5 kWh per day = 135 kWh per month
      double monthlyKWhGenerated = calculatedSystemSize.value * 4.5 * 30;
      monthlySavings.value = monthlyKWhGenerated * electricityRate.value;
    }

    // Calculate payback period
    double netCost = projectCost.value - totalSubsidy;
    if (monthlySavings.value > 0) {
      paybackPeriod.value = netCost / (monthlySavings.value * 12);
    } else {
      paybackPeriod.value = 0.0; // No savings, no payback
    }

    // Calculate 25-year savings
    if (monthlySavings.value > 0) {
      twentyFiveYearSavings.value = (monthlySavings.value * 12 * 25) - netCost;
    } else {
      twentyFiveYearSavings.value = 0.0; // No savings
    }

    // Calculate Environmental Impact
    // 1 kW solar system generates ~4.5 kWh per day = 1642.5 kWh per year
    // 1 kWh from grid produces ~0.82 kg CO2 (Indian grid average)
    double annualKWhGenerated = calculatedSystemSize.value * 4.5 * 365;
    co2Mitigated.value = annualKWhGenerated * 0.82; // kg CO2 per year

    // 1 tree absorbs ~22 kg CO2 per year
    treesPlanted.value = co2Mitigated.value / 22;

    // Update appliance loads for chart
    updateApplianceLoads();
  }

  void updateApplianceLoads() {
    applianceLoads.value = [
      ApplianceLoad(
        'Tubelights (LED/Tube)',
        numberOfTubelights.value * 18,
        AppColors.lightColor,
      ), // 18W
      ApplianceLoad(
        'LED Bulbs',
        numberOfLights.value * 9,
        AppColors.lightColor,
      ), // 9W
      ApplianceLoad(
        'Ceiling Fans',
        numberOfFans.value * 75,
        AppColors.fanColor,
      ), // 75W
      ApplianceLoad(
        'Wall Fans',
        numberOfWallFans.value * 55,
        AppColors.fanColor,
      ), // 55W
      ApplianceLoad(
        'Air Coolers',
        numberOfAirCoolers.value * 150,
        AppColors.acColor,
      ), // 150W
      ApplianceLoad(
        'TVs (LED, 32")',
        numberOfTVs.value * 60,
        AppColors.applianceColor,
      ), // 60W
      ApplianceLoad(
        'Refrigerators',
        numberOfRefrigerators.value * 180,
        AppColors.applianceColor,
      ), // 180W
      ApplianceLoad(
        'Washing Machines',
        numberOfAppliances.value * 500,
        AppColors.applianceColor,
      ), // 500W
      ApplianceLoad(
        'Water Purifiers',
        numberOfWaterPurifiers.value * 25,
        AppColors.applianceColor,
      ), // 25W
      ApplianceLoad(
        'Surface Water Pumps',
        numberOfSurfacePumps.value * 750,
        AppColors.applianceColor,
      ), // 750W
      ApplianceLoad(
        'Submersible Pumps',
        numberOfSubmersiblePumps.value * 1500,
        AppColors.applianceColor,
      ), // 1500W
      ApplianceLoad(
        'Air Conditioners (1.5T)',
        numberOfACs.value * 1500,
        AppColors.acColor,
      ), // 1500W
    ];
  }

  double get emiAmount {
    double netCost = projectCost.value - totalSubsidy;
    double monthlyRate = interestRate.value / (12 * 100);
    int totalMonths = (emiTenure.value * 12).round();

    if (monthlyRate == 0) return netCost / totalMonths;

    double emi =
        netCost *
        monthlyRate *
        pow(1 + monthlyRate, totalMonths) /
        (pow(1 + monthlyRate, totalMonths) - 1);
    return emi;
  }

  double get totalSubsidy {
    if (calculatedSystemSize.value < 1.0) return 0.0;
    if (calculatedSystemSize.value < 2.0) return 45000.0; // 1 kW tier
    if (calculatedSystemSize.value < 3.0) return 90000.0; // 2 kW tier
    return 108000.0; // 3 kW and above tier
  }

  double get netProjectCost => projectCost.value - totalSubsidy;

  // Methods to update values
  void updateDailyUsage(String value) {
    dailyUsageRupees.value = double.tryParse(value) ?? 0;
    calculateSystemSize();
  }

  void updateMonthlyUsage(String value) {
    monthlyUsageRupees.value = double.tryParse(value) ?? 0;
    calculateSystemSize();
  }

  void updateElectricityRate(double value) {
    electricityRate.value = value;
    calculateSystemSize();
  }

  void updateBillType(bool isMonthly) {
    isMonthlyBill.value = isMonthly;
    calculateSystemSize();
  }

  void updateFans(int value) {
    numberOfFans.value = value;
    calculateSystemSize();
  }

  void updateLights(int value) {
    numberOfLights.value = value;
    calculateSystemSize();
  }

  void updateACs(int value) {
    numberOfACs.value = value;
    calculateSystemSize();
  }

  void updateAppliances(int value) {
    numberOfAppliances.value = value;
    calculateSystemSize();
  }

  void updateTubelights(int value) {
    numberOfTubelights.value = value;
    calculateSystemSize();
  }

  void updateWallFans(int value) {
    numberOfWallFans.value = value;
    calculateSystemSize();
  }

  void updateAirCoolers(int value) {
    numberOfAirCoolers.value = value;
    calculateSystemSize();
  }

  void updateTVs(int value) {
    numberOfTVs.value = value;
    calculateSystemSize();
  }

  void updateRefrigerators(int value) {
    numberOfRefrigerators.value = value;
    calculateSystemSize();
  }

  void updateWaterPurifiers(int value) {
    numberOfWaterPurifiers.value = value;
    calculateSystemSize();
  }

  void updateSurfacePumps(int value) {
    numberOfSurfacePumps.value = value;
    calculateSystemSize();
  }

  void updateSubmersiblePumps(int value) {
    numberOfSubmersiblePumps.value = value;
    calculateSystemSize();
  }

  void updateSubsidyAmount(double value) {
    subsidyAmount.value = value;
    calculateSystemSize();
  }

  void updateEmiTenure(double value) {
    emiTenure.value = value;
  }

  void updateInterestRate(double value) {
    interestRate.value = value;
  }
}

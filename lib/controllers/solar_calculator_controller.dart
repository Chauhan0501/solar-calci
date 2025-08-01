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
  RxInt numberOfFans = 0.obs;
  RxInt numberOfLights = 0.obs;
  RxInt numberOfACs = 0.obs;
  RxInt numberOfAppliances = 0.obs;
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

    // Calculate based on appliances
    double applianceLoad =
        (numberOfFans.value * 75) + // 75W per fan
        (numberOfLights.value * 15) + // 15W per LED light
        (numberOfACs.value * 1500) + // 1500W per AC
        (numberOfAppliances.value * 500); // 500W per appliance

    // Convert to daily kWh (assuming 6 hours of usage)
    double applianceDailyKWh = (applianceLoad * 6) / 1000;

    // Use the higher of the two calculations
    double requiredDailyKWh = dailyUsageKWh > applianceDailyKWh
        ? dailyUsageKWh
        : applianceDailyKWh;

    // Solar system size (kW) = Daily kWh / (4.5 hours of peak sun * 0.75 efficiency)
    calculatedSystemSize.value = requiredDailyKWh / (4.5 * 0.75);

    // Calculate project cost (₹70,000 per kW)
    projectCost.value = calculatedSystemSize.value * 70000;

    // Calculate monthly savings
    if (isMonthlyBill.value) {
      monthlySavings.value = monthlyUsageRupees.value;
    } else {
      monthlySavings.value = dailyUsageRupees.value * 30;
    }

    // Calculate payback period
    double netCost = projectCost.value - subsidyAmount.value;
    paybackPeriod.value = netCost / (monthlySavings.value * 12);

    // Calculate 25-year savings
    twentyFiveYearSavings.value = (monthlySavings.value * 12 * 25) - netCost;

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
      ApplianceLoad('Fans', numberOfFans.value * 75, AppColors.fanColor),
      ApplianceLoad('Lights', numberOfLights.value * 15, AppColors.lightColor),
      ApplianceLoad('ACs', numberOfACs.value * 1500, AppColors.acColor),
      ApplianceLoad(
        'Appliances',
        numberOfAppliances.value * 500,
        AppColors.applianceColor,
      ),
    ];
  }

  double get emiAmount {
    double netCost = projectCost.value - subsidyAmount.value;
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

  double get totalSubsidy => subsidyAmount.value;
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

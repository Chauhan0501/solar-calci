import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/solar_calculator_controller.dart';
import '../constants/app_colors.dart';
import 'system_size_estimator.dart';
import 'subsidy_emi_calculator.dart';
import 'roi_payback_calculator.dart';
import 'load_chart_visual.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SystemSizeEstimator(),
    const SubsidyEmiCalculator(),
    // const RoiPaybackCalculator(),
    // const LoadChartVisual(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☀️ Solar Calculator'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'System Size',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Subsidy & EMI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'ROI & Payback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Load Chart',
          ),
        ],
      ),
    );
  }
}

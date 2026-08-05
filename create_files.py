import os

files = {
    "lib/features/charts/screens/charts_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/allocation_donut.dart';
import '../widgets/price_history_chart.dart';
import '../widgets/purchase_history_chart.dart';
import '../widgets/period_selector.dart';

class ChartsScreen extends HookConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.darkTextSecondary,
          tabs: const [
            Tab(text: 'Portfolio'),
            Tab(text: 'Allocation'),
            Tab(text: 'Prices'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _PortfolioTab().animate().fadeIn(),
          _AllocationTab().animate().fadeIn(),
          _PricesTab().animate().fadeIn(),
          _HistoryTab().animate().fadeIn(),
        ],
      ),
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PeriodSelector(),
        const SizedBox(height: 24),
        const SizedBox(
          height: 300,
          child: PortfolioChart(),
        ),
      ],
    );
  }
}

class _AllocationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(
          height: 300,
          child: AllocationDonut(),
        ),
      ],
    );
  }
}

class _PricesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PeriodSelector(),
        const SizedBox(height: 24),
        const Text('Gold', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const SizedBox(
          height: 200,
          child: PriceHistoryChart(isGold: true),
        ),
        const SizedBox(height: 32),
        const Text('Silver', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const SizedBox(
          height: 200,
          child: PriceHistoryChart(isGold: false),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(
          height: 300,
          child: PurchaseHistoryChart(),
        ),
      ],
    );
  }
}
""",
    "lib/features/charts/widgets/portfolio_chart.dart": """import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class PortfolioChart extends StatelessWidget {
  const PortfolioChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3000),
              FlSpot(1, 3200),
              FlSpot(2, 3100),
              FlSpot(3, 3500),
              FlSpot(4, 3800),
              FlSpot(5, 3700),
              FlSpot(6, 4200),
            ],
            isCurved: true,
            color: AppColors.gold,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.3),
                  AppColors.gold.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/charts/widgets/allocation_donut.dart": """import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AllocationDonut extends StatelessWidget {
  const AllocationDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 80,
        sections: [
          PieChartSectionData(
            color: AppColors.gold,
            value: 70,
            title: '70%',
            radius: 30,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: AppColors.silver,
            value: 30,
            title: '30%',
            radius: 30,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/charts/widgets/price_history_chart.dart": """import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class PriceHistoryChart extends StatelessWidget {
  final bool isGold;
  
  const PriceHistoryChart({super.key, required this.isGold});

  @override
  Widget build(BuildContext context) {
    final color = isGold ? AppColors.gold : AppColors.silver;
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 1.2),
              FlSpot(2, 1.1),
              FlSpot(3, 1.4),
              FlSpot(4, 1.3),
            ],
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/charts/widgets/purchase_history_chart.dart": """import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class PurchaseHistoryChart extends StatelessWidget {
  const PurchaseHistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppColors.gold)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: AppColors.silver)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: AppColors.gold)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppColors.silver)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: AppColors.gold)]),
        ],
      ),
    );
  }
}
""",
    "lib/features/charts/widgets/period_selector.dart": """import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/app_colors.dart';

class PeriodSelector extends HookWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(2);
    final periods = ['1W', '1M', '3M', '6M', '1Y', 'All'];

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(periods.length, (index) {
          final isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () => selectedIndex.value = index,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                periods[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.darkTextSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
""",
    "lib/features/statistics/screens/statistics_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/performance_meter.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PerformanceMeter(value: 12.5),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: StatCard(title: 'Gold Avg Buy', value: '£1,450 /oz', icon: Icons.diamond, color: AppColors.gold)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Silver Avg Buy', value: '£22.50 /oz', icon: Icons.diamond_outlined, color: AppColors.silver)),
            ],
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(title: 'Total Gold', value: '4.5 oz', icon: Icons.scale, color: AppColors.gold)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Total Silver', value: '120 oz', icon: Icons.scale, color: AppColors.silver)),
            ],
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Total Premium Paid', value: '£450.00', icon: Icons.money_off, color: Colors.orange).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Best Purchase', value: '1oz Gold Britannia (+24%)', icon: Icons.arrow_upward, color: AppColors.profit).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Worst Purchase', value: '1kg Silver Bar (-5%)', icon: Icons.arrow_downward, color: AppColors.loss).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }
}
""",
    "lib/features/statistics/widgets/stat_card.dart": """import 'package:flutter/material.dart';
import '../../../core/widgets/glass_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/statistics/widgets/performance_meter.dart": """import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class PerformanceMeter extends StatelessWidget {
  final double value;

  const PerformanceMeter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final isProfit = value >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return GlassCard(
      child: Column(
        children: [
          const Text('Historical ROI', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(isProfit ? Icons.arrow_upward : Icons.arrow_downward, color: color),
              Text(
                '${value.abs()}%',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/alerts/screens/alerts_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/metal_type.dart';
import '../widgets/alert_card.dart';
import 'create_alert_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price Alerts')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAlertScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AlertCard(metal: MetalType.gold, targetPrice: 2000, isAbove: true, isEnabled: true).animate().fadeIn(delay: 100.ms).slideX(),
          const SizedBox(height: 12),
          const AlertCard(metal: MetalType.silver, targetPrice: 25, isAbove: false, isEnabled: false).animate().fadeIn(delay: 200.ms).slideX(),
        ],
      ),
    );
  }
}
""",
    "lib/features/alerts/screens/create_alert_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class CreateAlertScreen extends HookConsumerWidget {
  const CreateAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetController = useTextEditingController();
    final isGold = useState(true);
    final isAbove = useState(true);

    return Scaffold(
      appBar: AppBar(title: const Text('New Alert')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Gold')),
              ButtonSegment(value: false, label: Text('Silver')),
            ],
            selected: {isGold.value},
            onSelectionChanged: (s) => isGold.value = s.first,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: targetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Price',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: 24),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Goes Above')),
              ButtonSegment(value: false, label: Text('Drops Below')),
            ],
            selected: {isAbove.value},
            onSelectionChanged: (s) => isAbove.value = s.first,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/alerts/widgets/alert_card.dart": """import 'package:flutter/material.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/entities/metal_type.dart';

class AlertCard extends StatelessWidget {
  final MetalType metal;
  final double targetPrice;
  final bool isAbove;
  final bool isEnabled;

  const AlertCard({
    super.key,
    required this.metal,
    required this.targetPrice,
    required this.isAbove,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: metal.displayColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\${metal.displayName} \${isAbove ? 'Above' : 'Below'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$ \$targetPrice', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (val) {},
            activeColor: metal.displayColor,
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/settings/screens/settings_screen.dart": """import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Preferences'),
          _buildListTile(Icons.currency_pound, 'Currency', trailing: const Text('GBP')),
          _buildListTile(Icons.scale, 'Weight Unit', trailing: const Text('Troy Oz')),
          _buildListTile(Icons.dark_mode, 'Theme', trailing: const Text('System')),
          
          _buildSectionHeader('Security'),
          _buildListTile(Icons.fingerprint, 'Biometric Lock', trailing: Switch(value: false, onChanged: (v){})),
          
          _buildSectionHeader('Data'),
          _buildListTile(Icons.cloud_upload, 'Cloud Backup', trailing: Switch(value: true, onChanged: (v){})),
          _buildListTile(Icons.file_download, 'Export to CSV'),
          _buildListTile(Icons.backup, 'Export JSON Backup'),
          _buildListTile(Icons.restore, 'Import Data'),
          
          _buildSectionHeader('About'),
          _buildListTile(Icons.info, 'App Version', trailing: const Text('1.0.0')),
          _buildListTile(Icons.privacy_tip, 'Privacy Policy'),
          _buildListTile(Icons.description, 'Terms of Service'),
          
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.loss, foregroundColor: Colors.white),
              onPressed: () {},
              child: const Text('Sign Out'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: trailing is Switch ? null : () {},
    );
  }
}
""",
    "lib/features/auth/screens/auth_screen.dart": """import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.darkBackground, Color(0xFF1A1A24)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.gold.withOpacity(0.2), AppColors.goldAccent.withOpacity(0.05)],
                        ),
                      ),
                      child: const Icon(Icons.diamond_outlined, size: 80, color: AppColors.gold),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 32),
                  const Text('Bullion Tracker', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  const Text('Track your precious metals portfolio', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.darkTextSecondary)).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  const Spacer(flex: 2),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _AuthButton(icon: Icons.apple, text: 'Sign in with Apple', onPressed: () {}, backgroundColor: Colors.white, textColor: Colors.black),
                        const SizedBox(height: 12),
                        _AuthButton(icon: Icons.g_mobiledata, text: 'Sign in with Google', onPressed: () {}, backgroundColor: AppColors.darkSurface, textColor: Colors.white),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Continue as Guest', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 32),
                  const Text('By continuing, you agree to our Terms of Service\\nand Privacy Policy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary)).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const _AuthButton({required this.icon, required this.text, required this.onPressed, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, foregroundColor: textColor, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
""",
    "lib/features/import_export/screens/import_export_screen.dart": """import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import / Export Data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Export', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.table_chart, color: AppColors.gold),
            title: const Text('Export to CSV'),
            subtitle: const Text('Export your holdings to a spreadsheet'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.backup, color: AppColors.gold),
            title: const Text('Export JSON Backup'),
            subtitle: const Text('Create a full backup of your data'),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Text('Import', style: TextStyle(color: AppColors.silver, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.upload_file, color: AppColors.silver),
            title: const Text('Import from CSV'),
            subtitle: const Text('Import holdings from a spreadsheet'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.restore, color: AppColors.silver),
            title: const Text('Restore from JSON'),
            subtitle: const Text('Restore data from a backup file'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
""",
    "lib/features/import_export/services/csv_service.dart": """class CsvService {
  Future<String> exportToCsv(List<dynamic> holdings) async {
    // Generate CSV string
    return "id,metal,weight,purchasePrice,date\\n1,Gold,1oz,1500,2023-01-01";
  }

  Future<List<dynamic>> importFromCsv(String csvString) async {
    // Parse CSV string
    return [];
  }
}
""",
    "lib/features/import_export/services/json_backup_service.dart": """import 'dart:convert';

class JsonBackupService {
  Future<String> createBackup(Map<String, dynamic> data) async {
    return jsonEncode(data);
  }

  Future<Map<String, dynamic>> restoreBackup(String jsonString) async {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
"""
}

base_path = '/Volumes/SSD/MetalTracker'

for rel_path, content in files.items():
    full_path = os.path.join(base_path, rel_path)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, 'w') as f:
        f.write(content)

print("All files created successfully!")

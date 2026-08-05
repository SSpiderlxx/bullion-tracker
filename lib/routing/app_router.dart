import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/prices/screens/prices_screen.dart';
import '../features/holdings/screens/holdings_list_screen.dart';
import '../features/holdings/screens/add_holding_screen.dart';
import '../features/holdings/screens/holding_detail_screen.dart';
import '../features/holdings/screens/sell_holding_screen.dart';
import '../features/charts/screens/charts_screen.dart';
import '../features/alerts/screens/alerts_screen.dart';
import '../features/alerts/screens/create_alert_screen.dart';
import '../features/statistics/screens/statistics_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/import_export/screens/import_export_screen.dart';
import '../domain/entities/holding.dart';
import '../core/theme/app_colors.dart';

/// Scaffold wrapper that provides a persistent bottom navigation bar
/// across the main app sections.
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        indicatorColor: AppColors.goldPrimary.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.goldPrimary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart, color: AppColors.goldPrimary),
            label: 'Prices',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.goldPrimary),
            label: 'Holdings',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: AppColors.goldPrimary),
            label: 'Charts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppColors.goldPrimary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Main application router configuration.
///
/// Uses a [StatefulShellRoute] to provide persistent bottom navigation
/// across the five main sections: Dashboard, Prices, Holdings, Charts, Settings.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Auth route (outside shell)
    GoRoute(
      path: '/auth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuthScreen(),
    ),
    // Main shell with bottom nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Dashboard tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        // Prices tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/prices',
              builder: (context, state) => const PricesScreen(),
            ),
          ],
        ),
        // Holdings tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/holdings',
              builder: (context, state) => const HoldingsListScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final holding = state.extra as Holding?;
                    return AddHoldingScreen(holding: holding);
                  },
                ),
                GoRoute(
                  path: 'detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final holding = state.extra as Holding;
                    return HoldingDetailScreen(holding: holding);
                  },
                  routes: [
                    GoRoute(
                      path: 'sell',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final holding = state.extra as Holding;
                        return SellHoldingScreen(holding: holding);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Charts tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/charts',
              builder: (context, state) => const ChartsScreen(),
            ),
          ],
        ),
        // Settings tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'alerts',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AlertsScreen(),
                  routes: [
                    GoRoute(
                      path: 'create',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) => const CreateAlertScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'statistics',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const StatisticsScreen(),
                ),
                GoRoute(
                  path: 'import-export',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ImportExportScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

import 'package:flutter/material.dart';

import '../platform/dashboard/dashboard_page.dart';
import '../platform/laboratory/laboratory_page.dart';
import '../platform/modules/modules_page.dart';
import '../platform/progress/progress_page.dart';
import '../platform/settings/settings_page.dart';

class MobileShell extends StatefulWidget {
  const MobileShell({super.key});

  static final GlobalKey<MobileShellState> shellKey = GlobalKey<MobileShellState>();
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  static void switchToTab(int index) {
    shellKey.currentState?.switchTo(index);
  }

  static void notifyDataChanged() {
    refreshNotifier.value++;
  }

  @override
  State<MobileShell> createState() => MobileShellState();
}

class MobileShellState extends State<MobileShell> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardPage(),
    ModulesPage(),
    LaboratoryPage(),
    ProgressPage(),
    SettingsPage(),
  ];

  void switchTo(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Módulos',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal_rounded),
            label: 'Laboratorio',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Progreso',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
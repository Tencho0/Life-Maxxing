// Dev-only home: tabs for the design-system gallery (foundations) and the
// component catalog. Temporary until the router shell lands in Phase 5.

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import 'gallery.dart';
import 'catalog.dart';

class DevHome extends StatelessWidget {
  const DevHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              const TabBar(
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textDim,
                indicatorColor: AppColors.accent,
                tabs: [Tab(text: 'Основи'), Tab(text: 'Компоненти')],
              ),
              const Expanded(
                child: TabBarView(
                  children: [Gallery(), ComponentCatalog()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

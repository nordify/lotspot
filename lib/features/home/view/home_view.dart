import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotspot/features/home/view/dock.dart';
import 'package:lotspot/features/map/map_page.dart';
import 'package:lotspot/features/settings/settings_page.dart';
import 'package:preload_page_view/preload_page_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final DockController _dockController = DockController();
  final PreloadPageController _pageController = PreloadPageController();
  int _currentScreen = 0;
  bool _pageSwitchFromDock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PreloadPageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          HapticFeedback.selectionClick();
          if (!_pageSwitchFromDock) {
            _dockController.moveSliderTo(index < 2 ? index : index + 1);
          }
          if (_pageSwitchFromDock) {
            if (_currentScreen == index) {
              _pageSwitchFromDock = false;
            }
          }
        },
        preloadPagesCount: 2,
        children: const [MapPage(), SettingsPage()],
      ),
      bottomNavigationBar: Dock(
        controller: _dockController,
        initialIndex: _currentScreen,
        onTap: (index) {
          _pageSwitchFromDock = true;

          if (_currentScreen != index) {
            _currentScreen = index;
          }
          _pageController.animateToPage(_currentScreen,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        },
        items: [DockTabItem(icon: Icons.map_rounded), DockTabItem(icon: Icons.person)],
      ),
    );
  }
}

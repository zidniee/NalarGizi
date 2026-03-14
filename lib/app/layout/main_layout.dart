import 'package:flutter/material.dart';
import 'package:nalargizi/app/router/app_router.dart';
import 'package:nalargizi/shared/widgets/custom_bottom_navigation_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int initialIndex;

  const MainLayout({super.key, required this.child, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate ke halaman sesuai index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRouter.growth);
        break;
      case 2:
        Navigator.pushNamed(context, AppRouter.quickAdd);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRouter.nutrition);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRouter.posyandu);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

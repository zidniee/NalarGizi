import 'dart:ui' show clampDouble;

import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFF43F5E);
    const inactiveColor = Color(0xFF94A3B8);
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final textScale = clampDouble(
      MediaQuery.textScalerOf(context).scale(1),
      1,
      1.3,
    );

    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final compactLayout = availableWidth < 380;
          final horizontalInset = clampDouble(availableWidth * 0.045, 12, 18);
          final bottomInset = clampDouble(availableWidth * 0.03, 10, 14);
          final outerButtonSize = clampDouble(availableWidth * 0.19, 66, 76);
          final buttonInnerPadding = compactLayout ? 5.0 : 6.0;
          final centerGap = outerButtonSize + (compactLayout ? 2 : 6);
          final barHeight = clampDouble(76 + ((textScale - 1) * 12), 76, 88);
          final totalHeight = barHeight + (outerButtonSize * 0.32);
          final barRadius = compactLayout ? 26.0 : 30.0;
          final navVerticalPadding = compactLayout ? 6.0 : 8.0;
          final iconSize = compactLayout ? 20.0 : 22.0;
          final labelSize = compactLayout ? 9.0 : 10.0;
          final labelSpacing = compactLayout ? 1.0 : 2.0;
          final itemIconPadding = compactLayout ? 5.0 : 6.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalInset,
              0,
              horizontalInset,
              bottomInset,
            ),
            child: SizedBox(
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: barHeight,
                      padding: EdgeInsets.fromLTRB(
                        12,
                        navVerticalPadding,
                        12,
                        navVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(barRadius),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _BottomNavItem(
                              label: 'Beranda',
                              icon: Icons.face_3_outlined,
                              isActive: currentIndex == 0,
                              activeColor: activeColor,
                              inactiveColor: inactiveColor,
                              iconSize: iconSize,
                              labelSize: labelSize,
                              iconPadding: itemIconPadding,
                              labelSpacing: labelSpacing,
                              onTap: () => onTap(0),
                            ),
                          ),
                          Expanded(
                            child: _BottomNavItem(
                              label: 'Kurva',
                              icon: Icons.bar_chart_rounded,
                              isActive: currentIndex == 1,
                              activeColor: activeColor,
                              inactiveColor: inactiveColor,
                              iconSize: iconSize,
                              labelSize: labelSize,
                              iconPadding: itemIconPadding,
                              labelSpacing: labelSpacing,
                              onTap: () => onTap(1),
                            ),
                          ),
                          SizedBox(width: centerGap),
                          Expanded(
                            child: _BottomNavItem(
                              label: 'Nutrisi',
                              icon: Icons.restaurant_outlined,
                              isActive: currentIndex == 3,
                              activeColor: activeColor,
                              inactiveColor: inactiveColor,
                              iconSize: iconSize,
                              labelSize: labelSize,
                              iconPadding: itemIconPadding,
                              labelSpacing: labelSpacing,
                              onTap: () => onTap(3),
                            ),
                          ),
                          Expanded(
                            child: _BottomNavItem(
                              label: 'Posyandu',
                              icon: Icons.calendar_month_outlined,
                              isActive: currentIndex == 4,
                              activeColor: activeColor,
                              inactiveColor: inactiveColor,
                              iconSize: iconSize,
                              labelSize: labelSize,
                              iconPadding: itemIconPadding,
                              labelSpacing: labelSpacing,
                              onTap: () => onTap(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onTap(2),
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: outerButtonSize,
                            height: outerButtonSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scaffoldColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(buttonInnerPadding),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFB7185),
                                    Color(0xFFE11D48),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: compactLayout ? 2.5 : 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFE11D48,
                                    ).withOpacity(0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: clampDouble(
                                  outerButtonSize * 0.42,
                                  26,
                                  32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;
  final double labelSize;
  final double iconPadding;
  final double labelSpacing;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.iconSize,
    required this.labelSize,
    required this.iconPadding,
    required this.labelSpacing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    final activeBackground = activeColor.withOpacity(0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: isActive ? activeBackground : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(height: labelSpacing),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: labelSize,
                  height: 1,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

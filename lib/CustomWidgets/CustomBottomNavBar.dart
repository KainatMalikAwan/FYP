import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onItemSelected;

  CustomBottomNavBar({
    required this.icons,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Color(0xFF199A8E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: icons.asMap().entries.map((entry) {
            final index = entry.key;
            final icon = entry.value;
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _NavItem(
                icon: icon,
                isSelected: isSelected,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  _NavItem({
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Icon(
        icon,
        color: isSelected ? Color(0xFF199A8E) : Colors.white,
        size: isSelected ? 33.0 : 20.0,
      ),
    );
  }
}

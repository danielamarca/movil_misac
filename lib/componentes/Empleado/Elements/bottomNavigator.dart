import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<BottomNavItem> navItems;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).cardColor,
      height: 70,
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var item in navItems) ...[
            if (navItems.indexOf(item) == 0 && navItems.length == 1) Spacer(),
            if (navItems.indexOf(item) == 1 && navItems.length == 2) Spacer(),
            _buildTabItem(item),
            if (navItems.indexOf(item) == 1 && navItems.length > 2) Spacer(),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem(BottomNavItem item) {
    final isSelected = selectedIndex == navItems.indexOf(item);
    return IconButton(
      icon: item.icon,
      color: isSelected ? Color.fromARGB(255, 227, 205, 107) : Colors.white,
      onPressed: () => onItemTapped(navItems.indexOf(item)),
    );
  }
}

class BottomNavItem {
  final Icon icon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.label,
  });
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomFloatingActionButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 231, 193, 39),
                Color.fromARGB(255, 175, 142, 8),
                Color.fromARGB(255, 7, 51, 103),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: onPressed,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }
}

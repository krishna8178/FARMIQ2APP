// lib/screens/main_layout.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'support_screen.dart';
import 'cart_screen.dart'; // Import the cart screen instead of the profile screen

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Replaced ProfileScreen with CartScreen in the list of pages.
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SupportScreen(),
    CartScreen(), // Changed from ProfileScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF3B5D46),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            activeIcon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          // Updated the icon and label from 'Profile' to 'Cart'.
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), // Changed icon
            activeIcon: Icon(Icons.shopping_cart),    // Changed active icon
            label: 'Cart',                             // Changed label
          ),
        ],
      ),
    );
  }
}
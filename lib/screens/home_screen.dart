// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:carrentalapp/screens/booking_history_page.dart';
import 'package:carrentalapp/screens/cars_page.dart';
import 'package:carrentalapp/screens/profile_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CarsPage(),
    BookingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  // Custom Bottom Navigation Bar with Increased Height
  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 70, // Set the desired height here (e.g., 70)
      decoration: BoxDecoration(
        color: Colors.blue.shade800, // Solid blue background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, -2), // Shadow for elevation effect
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.directions_car, 'Cars', 0),
          _buildNavItem(Icons.history, 'Bookings', 1),
          _buildNavItem(Icons.person, 'Profile', 2),
        ],
      ),
    );
  }

  // Helper method to build each navigation item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 30, // Larger icon size for better visibility
          ),
          const SizedBox(height: 4), // Spacing between icon and label
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/screens/cars_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carrentalapp/widgets/Available_Rental_Car_Card.dart';
import 'package:carrentalapp/widgets/Available_Booking_Car_Card.dart';
import 'package:carrentalapp/providers/available_rental_cars_provider.dart';
import 'package:carrentalapp/providers/available_booking_cars_provider.dart';

class CarsPage extends ConsumerWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingCars = ref.watch(availableBookingCarsProvider);
    final rentalCars = ref.watch(availableRentalCarsProvider);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade900, Colors.blue.shade600],
                ),
              ),
            ),
            title: Text(
              'Car Rental & Booking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800, // Dark blue for tabs
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.white, // White underline for selected tab
                      width: 3,
                    ),
                    insets: EdgeInsets.symmetric(
                        horizontal: 16), // Padding for the underline
                  ),
                  labelColor: Colors.white, // Selected tab text color
                  unselectedLabelColor:
                      Colors.white70, // Unselected tab text color
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(
                      child: Text('Booking'),
                    ),
                    Tab(
                      child: Text('Rental'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.white, // White background for the body
            child: TabBarView(
              children: [
                // Booking Tab
                bookingCars.isEmpty
                    ? Center(
                        child: Text(
                          'No cars available for booking.',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: bookingCars.length,
                        itemBuilder: (context, index) {
                          final car = bookingCars[index];
                          return AvailableBookingCarCard(car: car);
                        },
                      ),
                // Rental Tab
                rentalCars.isEmpty
                    ? Center(
                        child: Text(
                          'No cars found for rental.',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: rentalCars.length,
                        itemBuilder: (context, index) {
                          final car = rentalCars[index];
                          return AvailableRentalCarCard(car: car);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
}

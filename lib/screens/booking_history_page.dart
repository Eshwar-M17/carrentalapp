// lib/screens/bookings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booked_booking_cars_provider.dart';
import '../providers/rented_cars_provider.dart';
import 'package:carrentalapp/widgets/Booked_Car_Card.dart';
import 'package:carrentalapp/widgets/Rented_Car_Card.dart';

class BookingsPage extends ConsumerWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookedCars = ref.watch(bookedBookingCarsProvider);
    final rentedCars = ref.watch(rentedCarsProvider);

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
            'Your Confirmed Bookings',
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
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    child: Text('Booked Cars'),
                  ),
                  Tab(
                    child: Text('Rented Cars'),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              // Booked Cars Tab
              bookedCars.isEmpty
                  ? Center(
                      child: Text(
                        'No booked cars found.',
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: bookedCars.length,
                      itemBuilder: (context, index) {
                        final booking = bookedCars[index];
                        return BookedCarCard(booking: booking);
                      },
                    ),
              // Rented Cars Tab
              rentedCars.isEmpty
                  ? Center(
                      child: Text(
                        'No rented cars found.',
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: rentedCars.length,
                      itemBuilder: (context, index) {
                        final car = rentedCars[index];
                        return RentedCarCard(rental: car);
                      },
                    ),
          ],
        ),
      ),
    ));
  }
}
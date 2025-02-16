// lib/widgets/booked_car_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carrentalapp/models/car.dart';

class BookedCarCard extends StatelessWidget {
  final BookingCar booking;

  const BookedCarCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the pick-up date & time.
    final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
    final String pickUpDateTimeStr =
        dateTimeFormat.format(booking.pickUpDateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      elevation: 6, // Increased elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with car name and a "Booked" badge.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Booked',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Car model and seater information.
            Text(
              'Model: ${booking.carModel} | ${booking.seater}-Seater',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Pick-up date & time.
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Pick-up: $pickUpDateTimeStr',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Pick-up and drop-off locations.
            Text(
              'Pick-up Location: ${booking.pickUpLocation}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Drop-off Location: ${booking.dropOffLocation}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Pricing details in a row.
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '\$${booking.pricePerDay.toStringAsFixed(2)}/day',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '\$${booking.pricePerHour.toStringAsFixed(2)}/hr',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action button aligned to the right.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement navigation or cancellation logic here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700, // Solid blue color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

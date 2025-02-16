// lib/widgets/rented_car_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carrentalapp/models/car.dart';

class RentedCarCard extends StatelessWidget {
  final RentalCar rental;

  const RentedCarCard({Key? key, required this.rental}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the dates.
    final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
    final String bookingDateStr = dateTimeFormat.format(rental.bookingDate);
    final String rentStartStr = dateTimeFormat.format(rental.rentStartDate);
    final String endDateStr = dateTimeFormat.format(rental.endDate);

    // Determine rental status based on current date.
    final DateTime now = DateTime.now();
    String rentalStatus;
    Color statusColor;
    if (now.isBefore(rental.rentStartDate)) {
      rentalStatus = 'Upcoming';
      statusColor = Colors.orange;
    } else if (now.isAfter(rental.endDate)) {
      rentalStatus = 'Completed';
      statusColor = Colors.green;
    } else {
      rentalStatus = 'Active';
      statusColor = Colors.blue;
    }

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
            // Header with car name and rental status badge.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rental.name.toUpperCase(),
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
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    rentalStatus,
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
              'Model: ${rental.carModel} | ${rental.seater}-Seater',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Booking date.
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Booked on: $bookingDateStr',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Rental start and end dates.
            Row(
              children: [
                Icon(Icons.play_arrow, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Start: $rentStartStr',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.stop, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'End: $endDateStr',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Pricing details in a row.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '\$${rental.pricePerDay.toStringAsFixed(0)}/day',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '\$${rental.pricePerHour.toStringAsFixed(0)}/hr',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.speed, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '\$${rental.pricePerKm.toStringAsFixed(2)}/km',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Fuel type badge.
            Row(
              children: [
                Icon(Icons.local_gas_station, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    rental.fuelType,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

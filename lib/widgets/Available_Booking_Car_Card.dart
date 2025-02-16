// lib/widgets/available_booking_car_card.dart
import 'package:flutter/material.dart';
import 'package:carrentalapp/models/car.dart';
import 'package:carrentalapp/screens/car_booking_detail_screen.dart';

class AvailableBookingCarCard extends StatelessWidget {
  final BookingCar car;

  const AvailableBookingCarCard({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      elevation: 6, // Increased elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Car Image without Gradient Overlay
          Image.asset(
            car.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 40),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Name & Model
                Text(
                  '${car.name.toUpperCase()} | ${car.carModel}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Key Specifications
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${car.seater} Seater',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.local_gas_station, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      car.fuelType,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Pricing Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${car.pricePerDay.toStringAsFixed(0)}/day',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '\$${car.pricePerHour.toStringAsFixed(0)}/hr',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    // Book Now Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarBookingDetailsScreen(car: car),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue.shade700, // Solid blue color
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

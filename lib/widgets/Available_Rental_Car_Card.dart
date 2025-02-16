// lib/widgets/available_rental_car_card.dart
import 'package:flutter/material.dart';
import 'package:carrentalapp/models/car.dart'; // Ensure this imports RentalCar
import 'package:carrentalapp/screens/car_rental_detail_screen.dart';

class AvailableRentalCarCard extends StatelessWidget {
  final RentalCar car;

  const AvailableRentalCarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Optional: Define a placeholder for extras (if your model supports it)
    final String extras = "GPS, Air Conditioning, Advanced Safety";

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
          // Car Image with Rounded Corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Image.asset(
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
                    const SizedBox(width: 16),
                    Icon(Icons.settings, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Automatic',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Pricing Details in a Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price Per Day
                    Text(
                      '\$${car.pricePerDay.toStringAsFixed(0)}/day',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // Price Per Hour
                    Text(
                      '\$${car.pricePerHour.toStringAsFixed(0)}/hr',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    // Price Per Kilometer
                    Text(
                      '\$${car.pricePerKm.toStringAsFixed(2)}/km',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Optional Extras
                Text(
                  'Extras: $extras',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Rent Now Button Aligned to the Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarRentalDetailScreen(car: car),
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
                      child: const Text('Rent Now'),
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

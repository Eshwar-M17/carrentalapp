// lib/screens/car_booking_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:carrentalapp/models/car.dart';
import 'package:carrentalapp/providers/booked_booking_cars_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarBookingDetailsScreen extends ConsumerStatefulWidget {
  final BookingCar car;

  const CarBookingDetailsScreen({Key? key, required this.car})
      : super(key: key);

  @override
  ConsumerState createState() => _CarBookingDetailsScreenState();
}

class _CarBookingDetailsScreenState
    extends ConsumerState<CarBookingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _pickUpDateTime;
  final TextEditingController _pickUpLocationController =
      TextEditingController();
  final TextEditingController _dropOffLocationController =
      TextEditingController();

  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

  Future<void> _selectPickUpDateTime() async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _pickUpDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _pickUpDateTime != null
            ? TimeOfDay.fromDateTime(_pickUpDateTime!)
            : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _pickUpDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _confirmBooking() async {
    if (_formKey.currentState?.validate() != true || _pickUpDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all details correctly')),
      );
      return;
    }

    // Create a new BookingCar object using user inputs.
    final newBooking = BookingCar(
      id: "booking_${DateTime.now().millisecondsSinceEpoch}", // Generate a unique ID.
      name: widget.car.name,
      carModel: widget.car.carModel,
      seater: widget.car.seater,
      imageUrl: widget.car.imageUrl,
      fuelType: widget.car.fuelType,
      pricePerDay: widget.car.pricePerDay,
      pricePerHour: widget.car.pricePerHour,
      pickUpDateTime: _pickUpDateTime!,
      pickUpLocation: _pickUpLocationController.text.trim(),
      dropOffLocation: _dropOffLocationController.text.trim(),
    );

    try {
      // This call updates local state and writes the booking to Firestore.
      await ref.read(bookedBookingCarsProvider.notifier).addBooking(newBooking);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Log and show an error if writing to Firestore fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _pickUpLocationController.dispose();
    _dropOffLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${car.name}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Large Car Image with Hero Animation.
              Hero(
                tag: car.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    car.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Car Specifications Section.
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Specifications',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('${car.name} | ${car.carModel}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.event_seat, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${car.seater} Seater',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 16),
                          Icon(Icons.local_gas_station,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(car.fuelType,
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.settings, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Automatic',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Pricing Breakdown Section.
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pricing Breakdown',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price per Day: \$${car.pricePerDay.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price per Hour: \$${car.pricePerHour.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deposit: \$50 (refundable)',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Booking Details Section.
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Details',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Pick-up Date & Time Picker.
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Pick-up Date & Time',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectPickUpDateTime,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _pickUpDateTime == null
                                ? 'Select Pick-up Date & Time'
                                : _dateTimeFormat.format(_pickUpDateTime!),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pick-up Location Field.
                      TextFormField(
                        controller: _pickUpLocationController,
                        decoration: InputDecoration(
                          labelText: 'Pick-up Location',
                          labelStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          prefixIcon:
                              Icon(Icons.location_on, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Enter pick-up location'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      // Drop-off Location Field.
                      TextFormField(
                        controller: _dropOffLocationController,
                        decoration: InputDecoration(
                          labelText: 'Drop-off Location',
                          labelStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Enter drop-off location'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Terms & Conditions Section.
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Cancellation within 24 hours may incur a fee.\n'
                        '• A refundable deposit of \$50 is required.\n'
                        '• Ensure you have a valid driving license and insurance.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For support, contact us at support@carrentalapp.com',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Confirm Booking Button.
              ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Confirm Booking',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

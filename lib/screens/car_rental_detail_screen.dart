// lib/screens/car_rental_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:carrentalapp/models/car.dart'; // Ensure this imports RentalCar
import 'package:carrentalapp/providers/rented_cars_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentalapp/notification.dart';

class CarRentalDetailScreen extends ConsumerStatefulWidget {
  final RentalCar car;

  const CarRentalDetailScreen({Key? key, required this.car}) : super(key: key);

  @override
  ConsumerState createState() => _CarRentalDetailScreenState();
}

class _CarRentalDetailScreenState extends ConsumerState<CarRentalDetailScreen> {
  DateTime? _rentalStartDate;
  DateTime? _rentalEndDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  double? _totalCost;

  // Controllers for pickup and drop-off locations.
  final TextEditingController _pickupLocationController =
      TextEditingController();
  final TextEditingController _dropoffLocationController =
      TextEditingController();

  Future<void> _selectRentalStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _rentalStartDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && picked != _rentalStartDate) {
      setState(() {
        _rentalStartDate = picked;
        if (_rentalEndDate != null && _rentalEndDate!.isBefore(picked)) {
          _rentalEndDate = null;
        }
        _calculateTotalCost();
      });
    }
  }

  Future<void> _selectRentalEndDate(BuildContext context) async {
    if (_rentalStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a rental start date first.')),
      );
      return;
    }
    final DateTime initialDate =
        _rentalEndDate ?? _rentalStartDate!.add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _rentalStartDate!,
      lastDate: _rentalStartDate!.add(const Duration(days: 365)),
    );
    if (picked != null && picked != _rentalEndDate) {
      setState(() {
        _rentalEndDate = picked;
        _calculateTotalCost();
      });
    }
  }

  void _calculateTotalCost() {
    if (_rentalStartDate != null && _rentalEndDate != null) {
      int days = _rentalEndDate!.difference(_rentalStartDate!).inDays;
      if (days == 0) days = 1; // Minimum 1 day.
      _totalCost = days * widget.car.pricePerDay;
    }
  }

  Future<void> _confirmRental() async {
    if (_rentalStartDate == null ||
        _rentalEndDate == null ||
        _pickupLocationController.text.trim().isEmpty ||
        _dropoffLocationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Create a new RentalCar instance with updated dates.
    final newRental = RentalCar(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Unique ID as string
      name: widget.car.name,
      carModel: widget.car.carModel,
      seater: widget.car.seater,
      imageUrl: widget.car.imageUrl,
      fuelType: widget.car.fuelType,
      pricePerHour: widget.car.pricePerHour,
      pricePerDay: widget.car.pricePerDay,
      pricePerKm: widget.car.pricePerKm,
      bookingDate: DateTime.now(),
      rentStartDate: _rentalStartDate!,
      endDate: _rentalEndDate!,
    );

    // Add the new rental to the local provider.
    ref.read(rentedCarsProvider.notifier).addRental(newRental);

    // Write the new rental to Firestore under users/{userId}/rentedCars.
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final rentalData = newRental.toMap();
        rentalData['pickupLocation'] = _pickupLocationController.text.trim();
        rentalData['dropoffLocation'] = _dropoffLocationController.text.trim();
        rentalData['userId'] = user.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('rentedCars')
            .doc(newRental.id)
            .set(rentalData);
      } else {
        debugPrint("Error: No user logged in.");
      }
      await showBookingConfirmationNotification(newRental);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Rental booked from ${_dateFormat.format(_rentalStartDate!)} to ${_dateFormat.format(_rentalEndDate!)}.\n'
          'Pickup: ${_pickupLocationController.text.trim()} | Drop-off: ${_dropoffLocationController.text.trim()}\n'
          'Total: \$${_totalCost?.toStringAsFixed(2)}',
        ),
      ),
    );

// Inside _confirmRental method, after successful Firestore upload:
    try {
      // Schedule notification after successful booking
      await scheduleRentalProgressNotification(
        rentStartDate: newRental.rentStartDate,
        rentEndDate: newRental.endDate,
        car: newRental,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error scheduling reminder')),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropoffLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RentalCar car = widget.car;
    final String startDateText = _rentalStartDate != null
        ? _dateFormat.format(_rentalStartDate!)
        : 'Select Start Date';
    final String endDateText = _rentalEndDate != null
        ? _dateFormat.format(_rentalEndDate!)
        : 'Select End Date';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          car.name,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                        Text('Automatic', style: const TextStyle(fontSize: 14)),
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
                      'Price per Km: \$${car.pricePerKm.toStringAsFixed(2)}',
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
            // Rental Details Section.
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
                      'Rental Details',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Rental Start Date Picker.
                    OutlinedButton(
                      onPressed: () => _selectRentalStartDate(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(startDateText),
                    ),
                    const SizedBox(height: 16),
                    // Rental End Date Picker.
                    OutlinedButton(
                      onPressed: () => _selectRentalEndDate(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(endDateText),
                    ),
                    const SizedBox(height: 16),
                    // Pickup Location Field.
                    TextFormField(
                      controller: _pickupLocationController,
                      decoration: InputDecoration(
                        labelText: 'Pick-up Location',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        prefixIcon: Icon(Icons.location_on, color: Colors.grey),
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
                      controller: _dropoffLocationController,
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
                    const SizedBox(height: 16),
                    // Estimated Total Cost.
                    if (_totalCost != null)
                      Text(
                        'Estimated Total Cost: \$${_totalCost!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
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
                      '• Ensure you have a valid driving license and insurance.\n'
                      '• Mileage limits apply; extra kilometers will be charged accordingly.',
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
            // Confirm Rental Button.
            ElevatedButton(
              onPressed: _confirmRental,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:
                  const Text('Confirm Rental', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

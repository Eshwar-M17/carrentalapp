// lib/providers/available_booking_cars_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carrentalapp/models/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableBookingCarsNotifier extends StateNotifier<List<BookingCar>> {
  AvailableBookingCarsNotifier() : super([]) {
    loadAvailableBookingCars();
  }

  Future<void> loadAvailableBookingCars() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('bookingCars').get();
      state = snapshot.docs.map((doc) {
        // Include the document ID in the map if needed.
        final data = doc.data();
        data['id'] = doc.id;
        return BookingCar.fromMap(data);
      }).toList();
    } catch (e) {
      // Handle errors as needed.
      print('Error loading booking cars: $e');
    }
  }
}

final availableBookingCarsProvider =
    StateNotifierProvider<AvailableBookingCarsNotifier, List<BookingCar>>((ref) {
  return AvailableBookingCarsNotifier();
});

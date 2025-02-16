// lib/providers/available_rental_cars_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carrentalapp/models/car.dart'; // Ensure this imports RentalCar
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableRentalCarsNotifier extends StateNotifier<List<RentalCar>> {
  AvailableRentalCarsNotifier() : super([]) {
    loadAvailableRentalCars();
  }

  Future<void> loadAvailableRentalCars() async {
    try {
      // Query the "rentalCars" collection in Firestore.
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('rentalCars').get();

      // Map each document to a RentalCar object.
      state = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Optionally store the document ID in the model if required.
        data['id'] = doc.id;
        return RentalCar.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error loading rental cars: $e');
    }
  }
}

final availableRentalCarsProvider =
    StateNotifierProvider<AvailableRentalCarsNotifier, List<RentalCar>>((ref) {
  return AvailableRentalCarsNotifier();
});

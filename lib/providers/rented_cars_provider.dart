// lib/providers/rented_cars_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentalapp/models/car.dart';

class RentedCarsNotifier extends StateNotifier<List<RentalCar>> {
  RentedCarsNotifier() : super([]) {
    loadRentedCarsFromFirestore();
  }

  // Loads rented cars for the current user from Firestore.
  Future<void> loadRentedCarsFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Loading rented cars for user: ${user.uid}");
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('rentedCars')
            .get();
        final rentals = querySnapshot.docs.map((doc) {
          print("Loaded rental data: ${doc.data()}");
          return RentalCar.fromMap(doc.data());
        }).toList();
        state = rentals;
        print("Total rented cars loaded: ${state.length}");
      } else {
        print("No user logged in. Skipping loading rented cars.");
      }
    } catch (e, stacktrace) {
      print("Error loading rented cars from Firestore: $e");
      print(stacktrace);
    }
  }

  // Adds a new rental car booking to local state and writes it to Firestore.
  Future<void> addRental(RentalCar rental) async {
    try {
      // Update local state.
      state = [...state, rental];
      print("Rental added locally: ${rental.toMap()}");

      // Write the rental data to Firestore under users/{userId}/rentedCars.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final rentalData = rental.toMap();
        rentalData['userId'] = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('rentedCars')
            .doc(rental.id)
            .set(rentalData);
        print("Rental booking saved to Firestore for user: ${user.uid}");
      } else {
        print("Error: No user logged in. Cannot save rental to Firestore.");
      }
    } catch (e, stacktrace) {
      print("Error adding rental: $e");
      print(stacktrace);
    }
  }
}

final rentedCarsProvider =
    StateNotifierProvider<RentedCarsNotifier, List<RentalCar>>((ref) {
  return RentedCarsNotifier();
});

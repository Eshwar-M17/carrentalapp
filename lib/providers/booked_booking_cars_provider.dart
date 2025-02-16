// lib/providers/booked_booking_cars_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentalapp/models/car.dart';

class BookedBookingCarsNotifier extends StateNotifier<List<BookingCar>> {
  BookedBookingCarsNotifier() : super([]) {
    // When the provider is created, load bookings from Firestore.
    loadBookingsFromFirestore();
  }

  Future<void> loadBookingsFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .get();

      final bookings = querySnapshot.docs.map((doc) {
        return BookingCar.fromMap(doc.data());
      }).toList();

      // Update the state with the retrieved bookings.
      state = bookings;
    }
  }

  /// Adds a booking both to local state and Firestore.
  Future<void> addBooking(BookingCar booking) async {
    // Update local state.
    state = [...state, booking];

    // Save booking to Firestore under users/{userId}/bookings.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final bookingData = booking.toMap();
      // Optionally, include the user id explicitly.
      bookingData['userId'] = user.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .doc(booking.id) // You might consider using a generated unique ID.
          .set(bookingData);
    }
  }
}

final bookedBookingCarsProvider =
    StateNotifierProvider<BookedBookingCarsNotifier, List<BookingCar>>((ref) {
  return BookedBookingCarsNotifier();
});

// lib/models/booking.dart
import 'package:carrentalapp/models/car.dart'; // Ensure this imports RentalCar

class Booking {
  final int id;
  final RentalCar rentalCar; // Entire rental car object
  final DateTime bookingDate;
  final DateTime rentalStartDate; // The user-selected rental start date
  final DateTime returnDeadline;  // The user-selected rental end date
  final String status; // e.g., "Active", "Completed", "Penalty"

  Booking({
    required this.id,
    required this.rentalCar,
    required this.bookingDate,
    required this.rentalStartDate,
    required this.returnDeadline,
    required this.status,
  });
}

// lib/services/car_upload_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carrentalapp/models/car.dart';

class CarUploadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// List of Rental Cars
  List<RentalCar> get rentalCars => [
        RentalCar(
          id: 'rental1',
          name: 'BMW X5',
          carModel: 'X5 M',
          seater: 7,
          imageUrl: 'assets/images/BMW_X5.jpeg',
          fuelType: 'Diesel',
          pricePerHour: 30.0,
          pricePerDay: 200.0,
          pricePerKm: 2.0,
          bookingDate: DateTime.now(),
          rentStartDate: DateTime.now().add(Duration(days: 1)),
          endDate: DateTime.now().add(Duration(days: 5)),
        ),
        RentalCar(
          id: 'rental2',
          name: 'Mercedes-Benz GLC',
          carModel: 'GLC 300',
          seater: 5,
          imageUrl: 'assets/images/Mercedes_Benz_GLC.jpeg',
          fuelType: 'Petrol',
          pricePerHour: 25.0,
          pricePerDay: 180.0,
          pricePerKm: 1.8,
          bookingDate: DateTime.now(),
          rentStartDate: DateTime.now().add(Duration(days: 2)),
          endDate: DateTime.now().add(Duration(days: 6)),
        ),
        RentalCar(
          id: 'rental3',
          name: 'Toyota Camry',
          carModel: 'Camry Hybrid',
          seater: 5,
          imageUrl: 'assets/images/Toyota_Camry.jpeg',
          fuelType: 'Hybrid',
          pricePerHour: 20.0,
          pricePerDay: 150.0,
          pricePerKm: 1.5,
          bookingDate: DateTime.now(),
          rentStartDate: DateTime.now().add(Duration(days: 3)),
          endDate: DateTime.now().add(Duration(days: 7)),
        ),
        RentalCar(
          id: 'rental4',
          name: 'Tesla Model 3',
          carModel: 'Model 3 Long Range',
          seater: 5,
          imageUrl: 'assets/images/Tesla_Model_3.jpeg',
          fuelType: 'Electric',
          pricePerHour: 40.0,
          pricePerDay: 250.0,
          pricePerKm: 2.5,
          bookingDate: DateTime.now(),
          rentStartDate: DateTime.now().add(Duration(days: 4)),
          endDate: DateTime.now().add(Duration(days: 8)),
        ),
      ];

  /// List of Booking Cars
  List<BookingCar> get bookingCars => [
        BookingCar(
          id: 'booking1',
          name: 'Mercedes S Class',
          carModel: 'S 500',
          seater: 4,
          imageUrl: 'assets/images/mercedes_s_class.jpeg',
          fuelType: 'Electric',
          pricePerDay: 100000.0,
          pricePerHour: 1200.0,
          pickUpDateTime: DateTime.now(),
          pickUpLocation: 'Location A',
          dropOffLocation: 'Location B',
        ),
        BookingCar(
          id: 'booking2',
          name: 'Audi A8',
          carModel: 'A8 L',
          seater: 5,
          imageUrl: 'assets/images/Audi_A8.jpeg',
          fuelType: 'Petrol',
          pricePerDay: 80000.0,
          pricePerHour: 1000.0,
          pickUpDateTime: DateTime.now().add(Duration(days: 1)),
          pickUpLocation: 'Location C',
          dropOffLocation: 'Location D',
        ),
        BookingCar(
          id: 'booking3',
          name: 'Lexus LS',
          carModel: 'LS 500h',
          seater: 5,
          imageUrl: 'assets/images/Lexus_LS.jpeg',
          fuelType: 'Hybrid',
          pricePerDay: 90000.0,
          pricePerHour: 1100.0,
          pickUpDateTime: DateTime.now().add(Duration(days: 2)),
          pickUpLocation: 'Location E',
          dropOffLocation: 'Location F',
        ),
        BookingCar(
          id: 'booking4',
          name: 'Porsche Panamera',
          carModel: 'Panamera Turbo',
          seater: 4,
          imageUrl: 'assets/images/Porsche_Panamera.jpeg',
          fuelType: 'Petrol',
          pricePerDay: 120000.0,
          pricePerHour: 1500.0,
          pickUpDateTime: DateTime.now().add(Duration(days: 3)),
          pickUpLocation: 'Location G',
          dropOffLocation: 'Location H',
        ),
      ];

  /// Uploads a list of rental cars to the "rentalCars" collection in Firestore.
  Future<void> uploadRentalCars() async {
    WriteBatch batch = _firestore.batch();
    CollectionReference rentalCarsCollection = _firestore.collection('rentalCars');
    for (RentalCar car in rentalCars) {
      // Use car.id as document ID; ensure it's unique.
      DocumentReference docRef = rentalCarsCollection.doc(car.id);
      batch.set(docRef, car.toMap());
    }
    try {
      await batch.commit();
      print('Rental cars uploaded successfully!');
    } catch (e) {
      print('Error uploading rental cars: $e');
    }
  }

  /// Uploads a list of booking cars (for booking) to the "bookingCars" collection in Firestore.
  Future<void> uploadBookingCars() async {
    WriteBatch batch = _firestore.batch();
    CollectionReference bookingCarsCollection = _firestore.collection('bookingCars');
    for (BookingCar car in bookingCars) {
      // Use car.id as document ID; ensure it's unique.
      DocumentReference docRef = bookingCarsCollection.doc(car.id);
      batch.set(docRef, car.toMap());
    }
    try {
      await batch.commit();
      print('Booking cars uploaded successfully!');
    } catch (e) {
      print('Error uploading booking cars: $e');
    }
  }
}
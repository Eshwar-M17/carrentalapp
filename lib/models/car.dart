/// Common properties shared by all cars.
abstract class Car {
  final String id; // Unique identifier for each car.
  final String name;
  final String carModel;
  final int seater;
  final String imageUrl;
  final String fuelType;

  Car({
    required this.id,
    required this.name,
    required this.carModel,
    required this.seater,
    required this.imageUrl,
    required this.fuelType,
  });
}

/// Model for a car that's available for booking.
class BookingCar extends Car {
  final double pricePerDay;
  final double pricePerHour;
  final DateTime pickUpDateTime;
  final String pickUpLocation;
  final String dropOffLocation;

  BookingCar({
    required String id,
    required String name,
    required String carModel,
    required int seater,
    required String imageUrl,
    required String fuelType,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.pickUpDateTime,
    required this.pickUpLocation,
    required this.dropOffLocation,
  }) : super(
          id: id,
          name: name,
          carModel: carModel,
          seater: seater,
          imageUrl: imageUrl,
          fuelType: fuelType,
        );

  /// Converts a BookingCar object to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'carModel': carModel,
      'seater': seater,
      'imageUrl': imageUrl,
      'fuelType': fuelType,
      'pricePerDay': pricePerDay,
      'pricePerHour': pricePerHour,
      'pickUpDateTime': pickUpDateTime.toIso8601String(),
      'pickUpLocation': pickUpLocation,
      'dropOffLocation': dropOffLocation,
    };
  }

  /// Creates a BookingCar object from a Map.
  factory BookingCar.fromMap(Map<String, dynamic> map) {
    return BookingCar(
      id: map['id'] as String,
      name: map['name'] as String,
      carModel: map['carModel'] as String,
      seater: map['seater'] as int,
      imageUrl: map['imageUrl'] as String,
      fuelType: map['fuelType'] as String,
      pricePerDay: (map['pricePerDay'] as num).toDouble(),
      pricePerHour: (map['pricePerHour'] as num).toDouble(),
      pickUpDateTime: DateTime.parse(map['pickUpDateTime'] as String),
      pickUpLocation: map['pickUpLocation'] as String,
      dropOffLocation: map['dropOffLocation'] as String,
    );
  }
}

/// Model for a car that's available for rental.
class RentalCar extends Car {
  final double pricePerHour;
  final double pricePerDay;
  final double pricePerKm;
  final DateTime bookingDate;
  final DateTime rentStartDate;
  final DateTime endDate;

  RentalCar({
    required String id,
    required String name,
    required String carModel,
    required int seater,
    required String imageUrl,
    required String fuelType,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.pricePerKm,
    required this.bookingDate,
    required this.rentStartDate,
    required this.endDate,
  }) : super(
          id: id,
          name: name,
          carModel: carModel,
          seater: seater,
          imageUrl: imageUrl,
          fuelType: fuelType,
        );

  /// Converts a RentalCar object to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'carModel': carModel,
      'seater': seater,
      'imageUrl': imageUrl,
      'fuelType': fuelType,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'pricePerKm': pricePerKm,
      'bookingDate': bookingDate.toIso8601String(),
      'rentStartDate': rentStartDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  /// Creates a RentalCar object from a Map.
  factory RentalCar.fromMap(Map<String, dynamic> map) {
    return RentalCar(
      id: map['id'] as String,
      name: map['name'] as String,
      carModel: map['carModel'] as String,
      seater: map['seater'] as int,
      imageUrl: map['imageUrl'] as String,
      fuelType: map['fuelType'] as String,
      pricePerHour: (map['pricePerHour'] as num).toDouble(),
      pricePerDay: (map['pricePerDay'] as num).toDouble(),
      pricePerKm: (map['pricePerKm'] as num).toDouble(),
      bookingDate: DateTime.parse(map['bookingDate'] as String),
      rentStartDate: DateTime.parse(map['rentStartDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }
}

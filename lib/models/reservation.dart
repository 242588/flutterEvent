class Reservation {
  final int? id; // Nullable ID, utilisé pour l'auto-incrémentation
  final int userId;
  final int eventId;
  final int numberOfSeats;
  final String reservationDate;

  Reservation({
    this.id,
    required this.userId,
    required this.eventId,
    required this.numberOfSeats,
    required this.reservationDate,
  });

  // Mapper une réservation en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'numberOfSeats': numberOfSeats,
      'reservationDate': reservationDate,
    };
  }

  // Mapper une Map en réservation
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'], // Cela peut être null si c'est un auto-increment
      userId: map['userId'] ?? 0, // Si l'ID de l'utilisateur est manquant, mettre une valeur par défaut
      eventId: map['eventId'] ?? 0, // Valeur par défaut si manquante
      numberOfSeats: map['numberOfSeats'] ?? 0, // Valeur par défaut si manquante
      reservationDate: map['reservationDate'] ?? '', // Valeur vide si manquante
    );
  }
}

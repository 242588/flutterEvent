import 'package:projetv1/models/reservation.dart';
import 'package:projetv1/services/database_helper.dart';

class ReservationService {
  // Ajouter une réservation
  // Ajouter une réservation
  Future<void> addReservation(Reservation reservation) async {
    final db = await DatabaseHelper.instance.database;
    try {
      print('Ajout de la réservation: ${reservation.toMap()}');
      await db.insert('reservations', reservation.toMap());
      print('Réservation ajoutée avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout de la réservation: $e');
    }
  }

  

   // Obtenir toutes les réservations d’un utilisateur
  Future<List<Reservation>> getReservationsByUser(int userId) async {
    final db = await DatabaseHelper.instance.database;
    try {
      final maps = await db.query(
        'reservations',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      
      if (maps.isEmpty) {
        print('Aucune réservation trouvée pour l\'utilisateur $userId');
      }

      return maps.map((map) => Reservation.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors du chargement des réservations: $e');
      return [];
    }
  }
  Future<void> testAddReservation() async {
  final reservationService = ReservationService();
  
  Reservation reservation = Reservation(
    userId: 1,
    eventId: 1,
    numberOfSeats: 3,
    reservationDate: '2025-05-10',
  );
  
  await reservationService.addReservation(reservation);
  
  // Vérification des réservations dans la base de données
  final reservations = await reservationService.getReservationsByUser(1);
  print('Réservations récupérées: $reservations');
}

  // Supprimer une réservation
  Future<void> deleteReservation(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'reservations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> testFetchReservations() async {
  final reservationService = ReservationService();
  
  final reservations = await reservationService.getReservationsByUser(1);
  print('Réservations récupérées: $reservations');
}
  

  // Obtenir les réservations pour un événement donné
  Future<List<Reservation>> getReservationsByEvent(int eventId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'reservations',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return maps.map((map) => Reservation.fromMap(map)).toList();
  }
}

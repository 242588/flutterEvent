import 'package:flutter/material.dart';
import 'package:projetv1/main.dart';
import 'package:projetv1/models/reservation.dart';
import 'package:projetv1/services/reservation_service.dart';

class MyReservationsPage extends StatefulWidget {
  final int userId; // ID de l'utilisateur, passé en paramètre

  const MyReservationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MyReservationsPageState createState() => _MyReservationsPageState();
}



class _MyReservationsPageState extends State<MyReservationsPage> {
  late Future<List<Reservation>> _reservations;

  @override
  void initState() {
    super.initState();
    
    // Appel de la fonction de test ici
    testInsertAndFetch();

    _reservations = _fetchReservations();
  }

  Future<List<Reservation>> _fetchReservations() async {
    final reservationService = ReservationService();
    List<Reservation> reservations = await reservationService.getReservationsByUser(widget.userId);
    print('Réservations récupérées: $reservations'); // Pour vérifier dans le debug
    return reservations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Réservations'),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune réservation trouvée1111.'));
          } else {
            List<Reservation> reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ListTile(
                  title: Text('Événement ID: ${reservation.eventId}'),
                  subtitle: Text('Places: ${reservation.numberOfSeats}'),
                  trailing: Text(reservation.reservationDate),
                );
              },
            );
          }
        },
      ),
    );
  }
}

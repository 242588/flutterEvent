import 'package:flutter/material.dart';
import 'package:projetv1/models/event.dart';
import 'package:projetv1/models/reservation.dart';
import 'package:projetv1/services/reservation_service.dart';

class BookingPage extends StatefulWidget {
  final Event event;
  final int userId; // à passer depuis la session utilisateur

  BookingPage({required this.event, required this.userId});

  @override
  _BookingPageState createState() => _BookingPageState();
}



class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfSeats = 1;
  final ReservationService _reservationService = ReservationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver un événement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Lieu : ${widget.event.location}"),
              Text("Date : ${widget.event.date}"),
              Text("Heure : ${widget.event.time}"),
              Text("Prix : ${widget.event.price} TND"),
              SizedBox(height: 20),

              // Champ pour le nombre de places
              Text("Nombre de places à réserver :"),
              SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _numberOfSeats,
                items: List.generate(
                  widget.event.seats,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _numberOfSeats = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value < 1) {
                    return 'Veuillez choisir un nombre de places.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Bouton de réservation
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final reservation = Reservation(
                        userId: widget.userId,
                        eventId: widget.event.id!,
                        numberOfSeats: _numberOfSeats,
                        reservationDate: DateTime.now().toIso8601String(),
                      );
                      await _reservationService.addReservation(reservation);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Réservation confirmée !')),
                      );
                      Navigator.pop(context); // Retour à la page précédente
                    }
                  },
                  child: Text('Confirmer la réservation'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

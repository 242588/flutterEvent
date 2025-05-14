import 'package:flutter/material.dart';
import 'package:projetv1/models/event.dart';
import 'package:projetv1/services/database_helper.dart';
import 'package:projetv1/views/organizer/create_event_page.dart';
import 'package:projetv1/views/organizer/home/event_details_page.dart';
import 'package:projetv1/views/organizer/reservation/my_reservations_page.dart'; // ✅ N'oublie pas d'ajouter ce fichier !

class EventListPage extends StatefulWidget {
  final int currentUserId; // Ajout de l'ID de l'utilisateur (assurez-vous que c'est un String)

  // Vous pouvez passer l'ID de l'utilisateur lors de la navigation vers cette page
  EventListPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _eventsFuture = DatabaseHelper.instance.getAllEvents();
  }

  // Pour recharger la liste après création
  void _navigateToCreateEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventPage()),
    );
    setState(() {
      _loadEvents(); // recharge après retour
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Liste des Événements'),
  actions: [
    IconButton(
      icon: const Icon(Icons.event_note),
      tooltip: 'Mes Réservations',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyReservationsPage(userId: widget.currentUserId),
          ),
        );
      },
    ),
  ],
),

      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun événement disponible'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text('${event.date} à ${event.time} - ${event.location}'),
                  trailing: Text(event.price != null ? '${event.price} €' : 'Gratuit'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          event: event,
                          currentUserId: widget.currentUserId, // Passez l'ID de l'utilisateur
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      // ✅ BOUTON POUR AJOUTER UN ÉVÉNEMENT
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEvent,
        child: Icon(Icons.add),
        tooltip: 'Créer un événement',
      ),
    );
  }
}

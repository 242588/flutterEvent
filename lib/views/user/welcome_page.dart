import 'package:flutter/material.dart';
import 'package:projetv1/views/calendar_page.dart';
import '../../models/user.dart';
import '../organizer/home/event_list_page.dart';
import '../organizer/reservation/my_reservations_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue ${user.username}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Connecté en tant que : ${user.role}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventListPage(currentUserId: user.id!), // ✅ user.id ou widget.user.id
  ), 

              ),
              child: const Text("Voir les événements"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
MaterialPageRoute(builder: (_) => MyReservationsPage(userId: user.id!)),
              ),
              child: const Text("Mes réservations"),
            ),
            ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CalendarPage(currentUserId: user.id!)),
  ),
  child: const Text("Voir le calendrier"),
),
          ],
        ),
      ),
    );
  }
}

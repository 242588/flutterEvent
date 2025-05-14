import 'package:flutter/material.dart';
import 'package:projetv1/models/event.dart';
import 'package:projetv1/models/feedback_model.dart';
import 'package:projetv1/services/database_helper.dart';
import 'package:projetv1/views/organizer/EditEventPage.dart';
import 'package:projetv1/views/organizer/reservation/booking_page.dart';
import 'package:projetv1/views/shared/feedback_dialog.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;
  final int currentUserId;

  const EventDetailPage({Key? key, required this.event, required this.currentUserId}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late Future<List<FeedbackModel>> _feedbacks;

  @override
  void initState() {
    super.initState();
    _feedbacks = DatabaseHelper.instance.getFeedbacksForEvent(widget.event.id!);
  }

  void _reloadFeedbacks() {
    setState(() {
      _feedbacks = DatabaseHelper.instance.getFeedbacksForEvent(widget.event.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Catégorie : ${widget.event.category}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Date : ${widget.event.date} à ${widget.event.time}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Lieu : ${widget.event.location}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Places disponibles : ${widget.event.seats}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Prix : ${widget.event.price != null ? '${widget.event.price} €' : 'Gratuit'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Description :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.event.description ?? "Aucune description disponible"),
            SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(event: widget.event),
                    ),
                  );
                },
                child: Text("Modifier"),
              ),
            ),
            SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(event: widget.event, userId: widget.currentUserId),
                    ),
                  );
                },
                child: Text("Réserver cet événement"),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FeedbackDialog(
                      eventId: widget.event.id!,
                      userId: widget.currentUserId,
                      onFeedbackSubmitted: () {
                        Navigator.of(context).pop(); // Fermer le dialog
                        _reloadFeedbacks(); // Recharger les commentaires
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Merci pour votre avis !'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: Icon(Icons.rate_review),
                label: Text("Donner un avis"),
              ),
            ),
            SizedBox(height: 16),

            const SizedBox(height: 32),
            const Divider(thickness: 1.5),
            const Text("Commentaires des participants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            FutureBuilder<List<FeedbackModel>>(
              future: _feedbacks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucun avis pour cet événement.");
                }

                final feedbacks = snapshot.data!;
                return Column(
                  children: feedbacks.map((f) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < f.rating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: 20,
                            );
                          }),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.comment),
                            SizedBox(height: 4),
                            Text("Posté le ${f.date.split('T').first}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/feedback_model.dart';
import '../../services/database_helper.dart';

class EventFeedbackPage extends StatefulWidget {
  final int userId;
  final int eventId;

  const EventFeedbackPage({super.key, required this.userId, required this.eventId});

  @override
  State<EventFeedbackPage> createState() => _EventFeedbackPageState();
}

class _EventFeedbackPageState extends State<EventFeedbackPage> {
  int _rating = 3;
  final _commentController = TextEditingController();

  Future<void> _submitFeedback() async {
    final feedback = FeedbackModel(
      userId: widget.userId,
      eventId: widget.eventId,
      rating: _rating,
      comment: _commentController.text,
      date: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.insertFeedback(feedback);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Merci pour votre avis !")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donner un avis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Notez l'événement", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < _rating ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  )),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: "Votre commentaire"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}

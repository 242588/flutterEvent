import 'package:flutter/material.dart';
import 'package:projetv1/models/feedback_model.dart';
import 'package:projetv1/services/database_helper.dart';

class FeedbackDialog extends StatefulWidget {
  final int eventId;
  final int userId;
  final Function onFeedbackSubmitted;

  FeedbackDialog({
    required this.eventId,
    required this.userId,
    required this.onFeedbackSubmitted,
  });

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 1; // Valeur par défaut
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Donner un avis'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sélecteur de note
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),

              // Champ de texte pour le commentaire
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Laissez un commentaire',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un commentaire';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Boutons d'annulation et d'envoi
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Ferme la boîte de dialogue sans rien faire
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            // Vérification de la validité du formulaire
            if (_formKey.currentState!.validate()) {
              // Créer l'objet FeedbackModel avec les données de l'utilisateur
              FeedbackModel feedback = FeedbackModel(
                eventId: widget.eventId,
                userId: widget.userId,
                rating: _rating,
                comment: _commentController.text,
                date: DateTime.now().toIso8601String(),
              );

              try {
                // Sauvegarder le feedback dans la base de données
                await DatabaseHelper.instance.insertFeedback(feedback);

                // Fermer la boîte de dialogue après envoi
                Navigator.pop(context);

                // Afficher un SnackBar de confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Avis envoyé avec succès !')),
                );

                // Rafraîchir la liste des commentaires de l'événement
                widget.onFeedbackSubmitted();
              } catch (e) {
                // Afficher un SnackBar en cas d'erreur
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de l\'envoi de l\'avis.')),
                );
              }
            }
          },
          child: Text('Envoyer'),
        ),
      ],
    );
  }
}

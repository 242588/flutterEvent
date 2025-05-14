import 'package:flutter/material.dart';
import 'package:projetv1/models/event.dart';
import 'package:projetv1/services/database_helper.dart';

class EditEventPage extends StatefulWidget {
  final Event event;

  const EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  late TextEditingController _seatsController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _categoryController = TextEditingController(text: widget.event.category);
    _descriptionController = TextEditingController(text: widget.event.description);
    _dateController = TextEditingController(text: widget.event.date);
    _timeController = TextEditingController(text: widget.event.time);
    _locationController = TextEditingController(text: widget.event.location);
    _seatsController = TextEditingController(text: widget.event.seats.toString());
    _priceController = TextEditingController(text: widget.event.price?.toString() ?? '');
  }

  void _deleteEvent() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmer la suppression'),
      content: Text('Voulez-vous vraiment supprimer cet événement ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Supprimer'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await DatabaseHelper.instance.delete(widget.event.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Événement supprimé')),
    );

    // Revenir à la liste des événements
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        time: _timeController.text,
        location: _locationController.text,
        seats: int.parse(_seatsController.text),
        price: double.tryParse(_priceController.text),
      );

      final db = await DatabaseHelper.instance.database;

      await db.update(
        'events',
        updatedEvent.toMap(),
        where: 'id = ?',
        whereArgs: [widget.event.id],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Événement modifié avec succès')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier l'événement")),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Heure (HH:mm)'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Lieu'),
              ),
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(labelText: 'Nombre de places'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix (optionnel)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEvent,
                child: Text('Enregistrer les modifications'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _deleteEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Supprimer l\'événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

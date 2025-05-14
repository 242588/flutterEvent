import 'package:flutter/material.dart';
import 'package:projetv1/models/event.dart';
import 'package:projetv1/services/database_helper.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _seatsController = TextEditingController();
  final _priceController = TextEditingController();

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
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
      await db.insert('events', newEvent.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Événement ajouté avec succès')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un événement")),
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
                onPressed: _saveEvent,
                child: Text('Ajouter l\'événement'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

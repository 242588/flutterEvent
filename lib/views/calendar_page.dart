import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/event.dart'; // Adapte selon ton arborescence
import '../../../services/database_helper.dart';

class CalendarPage extends StatefulWidget {
  final int currentUserId;

  const CalendarPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Event>> _eventsByDate = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final events = await DatabaseHelper.instance.getAllEvents();
    
    Map<DateTime, List<Event>> grouped = {};

    // Imprimer les événements pour le débogage
    print('Récupération des événements:');
    for (var event in events) {
      try {
        DateTime eventDate = DateTime.parse(event.date);
        print('Event: ${event.title} - ${eventDate}');
        
        // Filtrer les événements à venir
        DateTime now = DateTime.now();
        if (eventDate.isAfter(now)) {
          grouped.putIfAbsent(eventDate, () => []).add(event);
        }
      } catch (e) {
        print('Erreur lors de la conversion de la date pour l\'événement: ${event.title}');
      }
    }

    setState(() {
      _eventsByDate = grouped;
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _eventsByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendrier des événements")),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? _focusedDay)
                  .map((event) => ListTile(
                        title: Text(event.title),
                        subtitle: Text('${event.date} à ${event.time}'),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

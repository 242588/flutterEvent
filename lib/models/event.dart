class Event {
  final int? id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final int seats;
  final double? price;

  Event({
    this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.seats,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'seats': seats,
      'price': price,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      location: map['location'],
      seats: map['seats'],
      price: map['price'],
    );
  }

  get availableSeats => null;
}

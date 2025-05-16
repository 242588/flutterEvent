class FeedbackModel {
  final int? id;
  final int userId;
  final int eventId;
  final int rating;
  final String comment;
  final String date;

  FeedbackModel({
    this.id,
    required this.userId,
    required this.eventId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      userId: map['userId'],
      eventId: map['eventId'],
      rating: map['rating'],
      comment: map['comment'],
      date: map['date'],
    );
  }
}

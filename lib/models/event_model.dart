class Event {
  final String name;
  final String location;
  final String matchDate;
  final int totalPlayers;
  final String createdBy;
  final String matchTime;
  final String host;
  final String notes;
  final String id;

  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.matchDate,
    required this.totalPlayers,
    required this.createdBy,
    required this.matchTime,
    required this.notes,
    required this.host
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      host:json['hostName'] ?? 'Javeria',
      name: json['matchName'] ?? '',
      location: json['matchLocation'] ?? '',
      matchDate: json['matchDate'] ?? '',
      totalPlayers: json['totalPlayers'] ?? '',
      createdBy: json['createdBy'] ?? '',
      matchTime: json['matchTime'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}

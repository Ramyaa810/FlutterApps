class Deck {
  final int? id;
  String name;

  Deck({this.id, required this.name});

  Deck copyWith({int? id, String? name}) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      name: map['name'],
    );
  }
}

class Beach {
  final int? id;
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double rating;
  final int priceLevel;
  final bool childrenFriendly;
  final bool surferFriendly;

  Beach({
    this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.priceLevel,
    required this.childrenFriendly,
    required this.surferFriendly,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'imagePath': imagePath,
      'rating': rating,
      'priceLevel': priceLevel,
      'childrenFriendly': childrenFriendly ? 1 : 0,
      'surferFriendly': surferFriendly ? 1 : 0,
    };
  }

  factory Beach.fromMap(Map<String, dynamic> map) {
    return Beach(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      description: map['description'],
      imagePath: map['imagePath'],
      rating: map['rating'],
      priceLevel: map['priceLevel'],
      childrenFriendly: map['childrenFriendly'] == 1,
      surferFriendly: map['surferFriendly'] == 1,
    );
  }
}

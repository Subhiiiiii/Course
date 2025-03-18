class Platform {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final bool hasFreeContent;
  final List<String> specialties;

  Platform({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.hasFreeContent,
    required this.specialties,
  });

  // Factory method to create a Platform from JSON
  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      description: json['description'],
      hasFreeContent: json['hasFreeContent'],
      specialties: List<String>.from(json['specialties']),
    );
  }

  // Method to convert Platform to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'hasFreeContent': hasFreeContent,
      'specialties': specialties,
    };
  }
}
class UserPreferences {
  double maxPrice;
  int? maxDurationInWeeks;
  String preferredLevel;
  String preferredLearningStyle;
  bool requiresCertificate;
  List<String> selectedPlatforms;
  List<String> selectedSkills;

  UserPreferences({
    this.maxPrice = double.infinity,
    this.maxDurationInWeeks,
    this.preferredLevel = 'any',
    this.preferredLearningStyle = 'any',
    this.requiresCertificate = false,
    List<String>? selectedPlatforms,
    List<String>? selectedSkills,
  }) : 
    selectedPlatforms = selectedPlatforms ?? [],
    selectedSkills = selectedSkills ?? [];
  
  // Creates a copy of the current preferences with optional new values
  UserPreferences copyWith({
    double? maxPrice,
    int? maxDurationInWeeks,
    String? preferredLevel,
    String? preferredLearningStyle,
    bool? requiresCertificate,
    List<String>? selectedPlatforms,
    List<String>? selectedSkills,
  }) {
    return UserPreferences(
      maxPrice: maxPrice ?? this.maxPrice,
      maxDurationInWeeks: maxDurationInWeeks ?? this.maxDurationInWeeks,
      preferredLevel: preferredLevel ?? this.preferredLevel,
      preferredLearningStyle: preferredLearningStyle ?? this.preferredLearningStyle,
      requiresCertificate: requiresCertificate ?? this.requiresCertificate,
      selectedPlatforms: selectedPlatforms != null ? List.from(selectedPlatforms) : List.from(this.selectedPlatforms),
      selectedSkills: selectedSkills != null ? List.from(selectedSkills) : List.from(this.selectedSkills),
    );
  }

  // Reset preferences to default values
  void reset() {
    maxPrice = double.infinity;
    maxDurationInWeeks = null;
    preferredLevel = 'any';
    preferredLearningStyle = 'any';
    requiresCertificate = false;
    selectedPlatforms.clear();
    selectedSkills.clear();
  }
}
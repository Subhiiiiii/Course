import 'package:course_connext/models/course.dart';
import 'package:course_connext/models/user_preferences.dart';

class RecommendationService {
  // Singleton pattern
  static final RecommendationService _instance = RecommendationService._internal();
  
  factory RecommendationService() {
    return _instance;
  }
  
  RecommendationService._internal();

  List<Course> getRecommendations(
    List<Course> allCourses, 
    UserPreferences preferences,
  ) {
    // Filter courses based on hard constraints from preferences
    final filteredCourses = allCourses.where((course) {
      // Price filter
      if (preferences.maxPrice < double.infinity && 
          course.price > preferences.maxPrice) {
        return false;
      }
      
      // // Duration filter
      // if (preferences.maxDurationInWeeks > 0 && 
      //     course.durationInWeeks > preferences.maxDurationInWeeks) {
      //   return false;
      // }
      
      // Level filter
      if (preferences.preferredLevel != 'any' && 
          course.level != preferences.preferredLevel) {
        return false;
      }
      
      // Learning style filter
      if (preferences.preferredLearningStyle != 'any' && 
          course.learningStyle != preferences.preferredLearningStyle) {
        return false;
      }
      
      // Platform filter
      if (preferences.selectedPlatforms.isNotEmpty && 
          !preferences.selectedPlatforms.contains(course.platformId)) {
        return false;
      }
      
      // Certificate filter
      if (preferences.requiresCertificate && !course.hasCertificate) {
        return false;
      }
      
      return true;
    }).toList();
    
    // Score and sort the filtered courses
    final scoredCourses = filteredCourses.map((course) {
      double score = 0;
      
      // Base score from rating
      score += course.rating * 10;
      
      // Bonus for popular courses
      score += _normalizeRatingCount(course.totalRatings);
      
      // Skill match score
      if (preferences.selectedSkills.isNotEmpty) {
        final matchedSkills = course.skills.where(
          (skill) => preferences.selectedSkills.contains(skill)
        ).length;
        
        final skillMatchRatio = matchedSkills / preferences.selectedSkills.length;
        score += skillMatchRatio * 50;
      }
      
      // Price score (cheaper is better, but free isn't always the best)
      if (course.price == 0) {
        score += 20;  // Free courses get a bonus
      } else {
        // For paid courses, lower price gets higher score
        score += (500 - course.price) / 10;
      }
      
      // Duration score (shorter courses slightly preferred)
      if (course.durationInWeeks < 4) {
        score += 5;  // Short courses get a small bonus
      }
      
      // Certificate bonus
      if (course.hasCertificate) {
        score += 10;
      }
      
      return MapEntry(course, score);
    }).toList();
    
    // Sort by score descending
    scoredCourses.sort((a, b) => b.value.compareTo(a.value));
    
    // Return top courses (up to 10)
    final recommendedCourses = scoredCourses.take(10).map((entry) => entry.key).toList();
    
    return recommendedCourses;
  }
  
  // Helper method to normalize rating count to a reasonable score value
  double _normalizeRatingCount(int count) {
    // Logarithmic scale to prevent very popular courses from dominating
    if (count == 0) return 0;
    return 10 * (1 + (count / 5000).clamp(0, 5));
  }
}

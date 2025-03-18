import '../models/course.dart';
import '../models/platform.dart';
import '../models/user_preferences.dart';
import 'mock_data.dart';

class CourseService {
  // Singleton pattern
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  // Get all available platforms
  Future<List<Platform>> getAllPlatforms() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would fetch from an API
    return MockData.platforms.map((json) => Platform.fromJson(json)).toList();
  }

  // Get courses based on user preferences
  Future<List<Course>> getCoursesByPreferences(UserPreferences preferences) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would make an API call with the preferences parameters
    return _filterCourses(MockData.courses, preferences);
  }

  // Get popular courses
  Future<List<Course>> getPopularCourses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    final courses = MockData.courses.map((json) => Course.fromJson(json)).toList();
    // Sort by rating and number of ratings to get the most popular
    courses.sort((a, b) {
      final aScore = a.rating * (1 + a.totalRatings / 100000);
      final bScore = b.rating * (1 + b.totalRatings / 100000);
      return bScore.compareTo(aScore);
    });
    
    return courses.take(10).toList();
  }

  // Get recommended courses based on user preferences
  Future<List<Course>> getRecommendedCourses(UserPreferences preferences) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));
    
    final filtered = _filterCourses(MockData.courses, preferences);
    // In a real app, this would use more sophisticated recommendation algorithms
    // For now, just return the highest-rated courses among the filtered ones
    filtered.sort((a, b) => b.rating.compareTo(a.rating));
    
    return filtered.take(5).toList();
  }

  // Get trending courses (newest ones with high ratings)
  Future<List<Course>> getTrendingCourses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 550));
    
    final courses = MockData.courses.map((json) => Course.fromJson(json)).toList();
    // This would typically consider date added and recent popularity
    // For demo, simply return some high-rated courses
    courses.shuffle(); // Randomize order to simulate variety in trending
    
    return courses.take(8).toList();
  }

  // Get course details by ID
  Future<Course> getCourseById(String courseId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final courseJson = MockData.courses.firstWhere(
      (course) => course['id'] == courseId,
      orElse: () => throw Exception('Course not found'),
    );
    
    return Course.fromJson(courseJson);
  }

  // Get similar courses to a given course
  Future<List<Course>> getSimilarCourses(Course course) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 650));
    
    final allCourses = MockData.courses.map((json) => Course.fromJson(json)).toList();
    
    // Filter out the source course
    final otherCourses = allCourses.where((c) => c.id != course.id).toList();
    
    // Calculate similarity based on common skills, level, and learning style
    otherCourses.sort((a, b) {
      final aCommonSkills = a.skills.where((skill) => course.skills.contains(skill)).length;
      final bCommonSkills = b.skills.where((skill) => course.skills.contains(skill)).length;
      
      // Simple similarity score
      final aScore = aCommonSkills * 3 + (a.level == course.level ? 2 : 0) + 
                     (a.learningStyle == course.learningStyle ? 1 : 0);
      final bScore = bCommonSkills * 3 + (b.level == course.level ? 2 : 0) + 
                     (b.learningStyle == course.learningStyle ? 1 : 0);
                     
      return bScore.compareTo(aScore);
    });
    
    return otherCourses.take(4).toList();
  }

  // Search courses by query string
  Future<List<Course>> searchCourses(String query, {UserPreferences? preferences}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (query.isEmpty) {
      return [];
    }
    
    final allCourses = MockData.courses.map((json) => Course.fromJson(json)).toList();
    
    // Filter by search query
    final queryLower = query.toLowerCase();
    final searchResults = allCourses.where((course) {
      return course.title.toLowerCase().contains(queryLower) || 
             course.description.toLowerCase().contains(queryLower) ||
             course.instructor.toLowerCase().contains(queryLower) ||
             course.skills.any((skill) => skill.toLowerCase().contains(queryLower));
    }).toList();
    
    // Apply additional filters if preferences are provided
    if (preferences != null) {
      return _applyPreferencesFilter(searchResults, preferences);
    }
    
    return searchResults;
  }

  // Helper method to filter courses based on user preferences
  List<Course> _filterCourses(List<Map<String, dynamic>> coursesJson, UserPreferences preferences) {
    final courses = coursesJson.map((json) => Course.fromJson(json)).toList();
    return _applyPreferencesFilter(courses, preferences);
  }

  // Apply preference filters to a list of courses
  List<Course> _applyPreferencesFilter(List<Course> courses, UserPreferences preferences) {
    return courses.where((course) {
      // Price filter
      if (preferences.maxPrice != double.infinity && course.price > preferences.maxPrice) {
        return false;
      }
      
      // Duration filter
      if (preferences.maxDurationInWeeks != null && 
          course.durationInWeeks > preferences.maxDurationInWeeks!) {
        return false;
      }
      
      // Level filter
      if (preferences.preferredLevel != 'any' && course.level != preferences.preferredLevel) {
        return false;
      }
      
      // Learning style filter
      if (preferences.preferredLearningStyle != 'any' && 
          course.learningStyle != preferences.preferredLearningStyle) {
        return false;
      }
      
      // Certificate filter
      if (preferences.requiresCertificate && !course.hasCertificate) {
        return false;
      }
      
      // Platform filter
      if (preferences.selectedPlatforms.isNotEmpty && 
          !preferences.selectedPlatforms.contains(course.platformId)) {
        return false;
      }
      
      // Skills filter - at least one skill should match
      if (preferences.selectedSkills.isNotEmpty) {
        final hasMatchingSkill = course.skills.any(
          (skill) => preferences.selectedSkills.contains(skill)
        );
        if (!hasMatchingSkill) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
}
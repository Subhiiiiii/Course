import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/user_preferences.dart';
import 'preferences_screen.dart';
import 'course_detail_screen.dart';
import '../services/course_service.dart';
import '../utils/constants.dart';
import '../widgets/course_card.dart';
import '../widgets/platform_filter.dart';
import '../widgets/price_range_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CourseService _courseService = CourseService();
  final TextEditingController _searchController = TextEditingController();
  
  late UserPreferences _userPreferences;
  List<String> _platforms = [];
  List<Course> _popularCourses = [];
  List<Course> _recommendedCourses = [];
  List<Course> _trendingCourses = [];
  List<Course> _coursesForComparison = [];
  bool _isLoading = true;
  bool _isSearching = false;
  List<Course> _searchResults = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _userPreferences = UserPreferences();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final platforms = await _courseService.getAllPlatforms();
      final popularCourses = await _courseService.getPopularCourses();
      final recommendedCourses = await _courseService.getRecommendedCourses(_userPreferences);
      final trendingCourses = await _courseService.getTrendingCourses();

      setState(() {
        _platforms = platforms.map((p) => p.id).toList();
        _popularCourses = popularCourses;
        _recommendedCourses = recommendedCourses;
        _trendingCourses = trendingCourses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading courses: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
        _searchQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });

    try {
      final results = await _courseService.searchCourses(query, preferences: _userPreferences);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      _showErrorSnackBar('Error searching courses: $e');
    }
  }

  void _toggleCourseComparison(Course course) {
    setState(() {
      if (_coursesForComparison.contains(course)) {
        _coursesForComparison.remove(course);
      } else {
        if (_coursesForComparison.length < 3) {
          _coursesForComparison.add(course);
        } else {
          _showErrorSnackBar('You can compare up to 3 courses at a time');
        }
      }
    });
  }

  void _navigateToCourseDetails(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
  }

  void _navigateToComparisonScreen() {
    if (_coursesForComparison.length < 2) {
      _showErrorSnackBar('Select at least 2 courses to compare');
      return;
    }
    
    Navigator.of(context).pushNamed(
      '/comparison',
      arguments: _coursesForComparison,
    );
  }

  void _openPreferencesScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreferencesScreen(preferences: _userPreferences),
      ),
    );

    if (result != null && result is UserPreferences) {
      setState(() {
        _userPreferences = result;
      });
      
      // Reload data with new preferences
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onSubmitted: (_) => _search(),
              )
            : const Text('Course Connext'),
        actions: [
          // Search icon
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchResults.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          // Compare courses button
          if (_coursesForComparison.isNotEmpty)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: _navigateToComparisonScreen,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_coursesForComparison.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          // Preferences button
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openPreferencesScreen,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: _isSearching && _searchQuery.isNotEmpty
                  ? _buildSearchResults()
                  : _buildHomeContent(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Only home is implemented for the demo
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This feature will be available in a future update.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform filters
          PlatformFilter(
            platforms: _platforms,
            selectedPlatforms: _userPreferences.selectedPlatforms,
            onSelectionChanged: (platforms) {
              setState(() {
                _userPreferences.selectedPlatforms = platforms;
              });
              _loadData();
            },
          ),
          
          // Price slider
          PriceRangeSlider(
            currentValue: _userPreferences.maxPrice == double.infinity ? 500 : _userPreferences.maxPrice,
            onChanged: (value) {
              setState(() {
                _userPreferences.maxPrice = value >= 500 ? double.infinity : value;
              });
              _loadData();
            },
          ),
          
          const Divider(),
          
          // Recommended courses section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended for You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all functionality would go here
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                _recommendedCourses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No recommended courses found with your current preferences.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recommendedCourses.length,
                          itemBuilder: (context, index) {
                            final course = _recommendedCourses[index];
                            return Container(
                              width: 250,
                              padding: const EdgeInsets.only(right: 16),
                              child: CourseCard(
                                course: course,
                                isInComparison: _coursesForComparison.contains(course),
                                onToggleComparison: () => _toggleCourseComparison(course),
                                onTap: () => _navigateToCourseDetails(course),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Popular courses section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Most Popular',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all functionality would go here
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                _popularCourses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No popular courses found with your current preferences.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _popularCourses.length,
                          itemBuilder: (context, index) {
                            final course = _popularCourses[index];
                            return Container(
                              width: 250,
                              padding: const EdgeInsets.only(right: 16),
                              child: CourseCard(
                                course: course,
                                isInComparison: _coursesForComparison.contains(course),
                                onToggleComparison: () => _toggleCourseComparison(course),
                                onTap: () => _navigateToCourseDetails(course),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Trending courses section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trending Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all functionality would go here
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                _trendingCourses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No trending courses found with your current preferences.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _trendingCourses.length,
                          itemBuilder: (context, index) {
                            final course = _trendingCourses[index];
                            return Container(
                              width: 250,
                              padding: const EdgeInsets.only(right: 16),
                              child: CourseCard(
                                course: course,
                                isInComparison: _coursesForComparison.contains(course),
                                onToggleComparison: () => _toggleCourseComparison(course),
                                onTap: () => _navigateToCourseDetails(course),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term or adjust your filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final course = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CourseCard(
            course: course,
            isInComparison: _coursesForComparison.contains(course),
            onToggleComparison: () => _toggleCourseComparison(course),
            onTap: () => _navigateToCourseDetails(course),
          ),
        );
      },
    );
  }
}
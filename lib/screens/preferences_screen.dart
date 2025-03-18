import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../utils/constants.dart';
import '../services/course_service.dart';

class PreferencesScreen extends StatefulWidget {
  final UserPreferences preferences;

  const PreferencesScreen({Key? key, required this.preferences}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late UserPreferences _preferences;
  final CourseService _courseService = CourseService();
  List<String> _availablePlatforms = [];
  List<String> _availableSkills = [];
  bool _isLoading = true;

  final List<String> _commonSkills = [
    'Python',
    'JavaScript',
    'Machine Learning',
    'Web Development',
    'Data Science',
    'UX Design',
    'Mobile Development',
    'Cloud Computing',
    'Artificial Intelligence',
    'Cybersecurity',
    'Business',
    'Marketing',
  ];

  @override
  void initState() {
    super.initState();
    _preferences = widget.preferences.copyWith();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Get platforms
    final platforms = await _courseService.getAllPlatforms();
    _availablePlatforms = platforms.map((p) => p.id).toList();

    // For skills, we'll use a predefined list of common skills for simplicity
    _availableSkills = _commonSkills;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Learning Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_preferences);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price preference
                  _buildSectionTitle('Budget'),
                  _buildPriceSlider(),
                  const Divider(),

                  // Duration preference
                  _buildSectionTitle('Course Duration'),
                  _buildDurationDropdown(),
                  const Divider(),

                  // Level preference
                  _buildSectionTitle('Preferred Level'),
                  _buildLevelSelector(),
                  const Divider(),

                  // Learning style preference
                  _buildSectionTitle('Learning Style'),
                  _buildLearningStyleSelector(),
                  const Divider(),

                  // Platform selection
                  _buildSectionTitle('Platforms'),
                  _buildPlatformSelector(),
                  const Divider(),

                  // Skills selection
                  _buildSectionTitle('Skills'),
                  _buildSkillsSelector(),
                  const Divider(),

                  // Certificate preference
                  _buildSectionTitle('Certificate'),
                  SwitchListTile(
                    title: const Text('Require Certificate'),
                    subtitle: const Text('Only show courses that offer a certificate upon completion'),
                    value: _preferences.requiresCertificate,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _preferences = _preferences.copyWith(requiresCertificate: value);
                      });
                    },
                  ),
                  const Divider(),

                  // Reset button
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _preferences.reset();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset All Preferences'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriceSlider() {
    final double value = _preferences.maxPrice == double.infinity ? 500.0 : _preferences.maxPrice;
    
    return Column(
      children: [
        Slider(
          value: value,
          min: 0,
          max: 500,
          divisions: 10,
          label: value == 500 ? 'Any price' : '\$${value.toInt()}',
          onChanged: (newValue) {
            setState(() {
              _preferences = _preferences.copyWith(
                maxPrice: newValue == 500 ? double.infinity : newValue,
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Free', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                value == 500 ? 'Any price' : '\$${value.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationDropdown() {
    return DropdownButtonFormField<int>(
      value: _preferences.maxDurationInWeeks,
      decoration: const InputDecoration(
        hintText: 'Select maximum duration',
      ),
      items: AppConstants.durationOptions.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _preferences = _preferences.copyWith(maxDurationInWeeks: value);
        });
      },
    );
  }

  Widget _buildLevelSelector() {
    return Wrap(
      spacing: 8.0,
      children: AppConstants.learningLevels.map((level) {
        final isSelected = _preferences.preferredLevel == level;
        return ChoiceChip(
          label: Text(level == 'any' ? 'Any level' : level),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _preferences = _preferences.copyWith(preferredLevel: level);
              });
            }
          },
          backgroundColor: Colors.grey[200],
          selectedColor: AppColors.primaryLight,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLearningStyleSelector() {
    return Wrap(
      spacing: 8.0,
      children: AppConstants.learningStyles.map((style) {
        final isSelected = _preferences.preferredLearningStyle == style;
        String displayText;
        
        switch (style) {
          case 'any':
            displayText = 'Any style';
            break;
          case 'project-based':
            displayText = 'Project-based';
            break;
          default:
            displayText = style;
        }
        
        return ChoiceChip(
          label: Text(displayText),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _preferences = _preferences.copyWith(preferredLearningStyle: style);
              });
            }
          },
          backgroundColor: Colors.grey[200],
          selectedColor: AppColors.primaryLight,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlatformSelector() {
    return Wrap(
      spacing: 8.0,
      children: _availablePlatforms.map((platform) {
        final isSelected = _preferences.selectedPlatforms.contains(platform);
        String displayName;
        
        switch (platform) {
          case 'coursera':
            displayName = 'Coursera';
            break;
          case 'udemy':
            displayName = 'Udemy';
            break;
          case 'edx':
            displayName = 'edX';
            break;
          case 'udacity':
            displayName = 'Udacity';
            break;
          case 'skillshare':
            displayName = 'Skillshare';
            break;
          case 'pluralsight':
            displayName = 'Pluralsight';
            break;
          default:
            displayName = platform;
        }
        
        return FilterChip(
          label: Text(displayName),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _preferences = _preferences.copyWith(
                  selectedPlatforms: [..._preferences.selectedPlatforms, platform],
                );
              } else {
                _preferences = _preferences.copyWith(
                  selectedPlatforms: _preferences.selectedPlatforms
                      .where((p) => p != platform)
                      .toList(),
                );
              }
            });
          },
          backgroundColor: Colors.grey[200],
          selectedColor: AppColors.primaryLight,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select skills you want to learn',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: _availableSkills.map((skill) {
            final isSelected = _preferences.selectedSkills.contains(skill);
            return FilterChip(
              label: Text(skill),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _preferences = _preferences.copyWith(
                      selectedSkills: [..._preferences.selectedSkills, skill],
                    );
                  } else {
                    _preferences = _preferences.copyWith(
                      selectedSkills: _preferences.selectedSkills
                          .where((s) => s != skill)
                          .toList(),
                    );
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppColors.primaryLight,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
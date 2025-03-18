import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PlatformFilter extends StatelessWidget {
  final List<String> platforms;
  final List<String> selectedPlatforms;
  final Function(List<String>) onSelectionChanged;

  const PlatformFilter({
    Key? key,
    required this.platforms,
    required this.selectedPlatforms,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            const SizedBox(width: 8),
            const Text('Platforms:'),
            const SizedBox(width: 8),
            ...platforms.map((platform) => _buildPlatformChip(platform)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformChip(String platform) {
    final isSelected = selectedPlatforms.contains(platform);
    String displayName;
    Color chipColor;
    
    switch (platform) {
      case 'coursera':
        displayName = 'Coursera';
        chipColor = const Color(0xFF0056D2); // Coursera blue
        break;
      case 'udemy':
        displayName = 'Udemy';
        chipColor = const Color(0xFFA435F0); // Udemy purple
        break;
      case 'edx':
        displayName = 'edX';
        chipColor = const Color(0xFF02262B); // edX dark teal
        break;
      case 'udacity':
        displayName = 'Udacity';
        chipColor = const Color(0xFF01B3E3); // Udacity blue
        break;
      case 'skillshare':
        displayName = 'Skillshare';
        chipColor = const Color(0xFF00FF84); // Skillshare green
        break;
      case 'pluralsight':
        displayName = 'Pluralsight';
        chipColor = const Color(0xFFF15B2A); // Pluralsight orange
        break;
      default:
        displayName = platform;
        chipColor = AppColors.primary;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(displayName),
        selected: isSelected,
        onSelected: (selected) {
          final updatedSelection = List<String>.from(selectedPlatforms);
          if (selected) {
            updatedSelection.add(platform);
          } else {
            updatedSelection.remove(platform);
          }
          onSelectionChanged(updatedSelection);
        },
        backgroundColor: Colors.grey[200],
        selectedColor: chipColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
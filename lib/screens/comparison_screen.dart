import 'package:flutter/material.dart';
import 'package:course_connext/models/course.dart';
import 'package:course_connext/widgets/comparison_table.dart';
import 'package:course_connext/utils/constants.dart';

class ComparisonScreen extends StatelessWidget {
  final List<Course> courses;

  const ComparisonScreen({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Comparison'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compare Courses',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comparing ${courses.length} courses',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Course titles in header row
            Row(
              children: [
                const SizedBox(width: 120), // Space for feature column
                ...courses.map((course) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          course.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
            
            // Platform row
            ComparisonTableRow(
              title: 'Platform',
              values: courses.map((c) => c.platformName).toList(),
              isColored: true,
            ),
            
            // Price row
            ComparisonTableRow(
              title: 'Price',
              values: courses.map((c) => c.getPriceText()).toList(),
              isColored: false,
              highlightBest: true,
              bestIsCheapest: true,
            ),
            
            // Rating row
            ComparisonTableRow(
              title: 'Rating',
              values: courses.map((c) => '${c.rating} (${c.totalRatings})').toList(),
              isColored: true,
              highlightBest: true,
              bestIsCheapest: false,
            ),
            
            // Duration row
            ComparisonTableRow(
              title: 'Duration',
              values: courses.map((c) => c.getDurationText()).toList(),
              isColored: false,
            ),
            
            // Level row
            ComparisonTableRow(
              title: 'Level',
              values: courses.map((c) => c.level.substring(0, 1).toUpperCase() + c.level.substring(1)).toList(),
              isColored: true,
            ),
            
            // Learning style row
            ComparisonTableRow(
              title: 'Learning Style',
              values: courses.map((c) => _getLearningStyleText(c.learningStyle)).toList(),
              isColored: false,
            ),
            
            // Certificate row
            ComparisonTableRow(
              title: 'Certificate',
              values: courses.map((c) => c.hasCertificate ? 'Yes' : 'No').toList(),
              isColored: true,
            ),
            
            // Skills row
            ComparisonTableRow(
              title: 'Top Skills',
              values: courses.map((c) {
                final topSkills = c.skills.take(3).join(', ');
                return topSkills.isEmpty ? 'N/A' : topSkills;
              }).toList(),
              isColored: false,
              isMultiline: true,
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: courses.map((course) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/course-detail',
                        arguments: course,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('View Details'),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getLearningStyleText(String style) {
    switch (style) {
      case 'video':
        return 'Video Lectures';
      case 'interactive':
        return 'Interactive';
      case 'text':
        return 'Text-based';
      case 'project-based':
        return 'Project-based';
      default:
        return style;
    }
  }
}

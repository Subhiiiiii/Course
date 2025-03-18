import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/constants.dart';

class CourseComparisonScreen extends StatelessWidget {
  final List<Course> courses;

  const CourseComparisonScreen({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Comparison'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: courses.length < 2
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Select at least 2 courses to compare',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Course Comparison',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildComparisonTable(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        headingRowColor: MaterialStateProperty.all(AppColors.lightGrey),
        columns: [
          const DataColumn(
            label: Text(
              'Feature',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...courses.map((course) => DataColumn(
                label: Expanded(
                  child: Text(
                    course.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )),
        ],
        rows: [
          // Platform row
          DataRow(
            cells: [
              const DataCell(Text('Platform', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(Text(course.platformName))),
            ],
          ),
          // Price row
          DataRow(
            cells: [
              const DataCell(Text('Price', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(
                    Text(
                      course.getPriceText(),
                      style: TextStyle(
                        color: course.price == 0 ? AppColors.success : null,
                        fontWeight: course.price == 0 ? FontWeight.bold : null,
                      ),
                    ),
                  )),
            ],
          ),
          // Duration row
          DataRow(
            cells: [
              const DataCell(Text('Duration', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(Text(course.getDurationText()))),
            ],
          ),
          // Level row
          DataRow(
            cells: [
              const DataCell(Text('Level', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(Text(
                    course.level.substring(0, 1).toUpperCase() + course.level.substring(1),
                  ))),
            ],
          ),
          // Rating row
          DataRow(
            cells: [
              const DataCell(Text('Rating', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(
                    Row(
                      children: [
                        Text('${course.rating} '),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' (${_formatRatingCount(course.totalRatings)})')
                      ],
                    ),
                  )),
            ],
          ),
          // Learning Style row
          DataRow(
            cells: [
              const DataCell(Text('Learning Style', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(Text(_formatLearningStyle(course.learningStyle)))),
            ],
          ),
          // Certificate row
          DataRow(
            cells: [
              const DataCell(Text('Certificate', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(
                    course.hasCertificate
                        ? const Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.success, size: 18),
                              SizedBox(width: 4),
                              Text('Yes'),
                            ],
                          )
                        : const Row(
                            children: [
                              Icon(Icons.cancel, color: Colors.grey, size: 18),
                              SizedBox(width: 4),
                              Text('No'),
                            ],
                          ),
                  )),
            ],
          ),
          // Skills row
          DataRow(
            cells: [
              const DataCell(Text('Skills', style: TextStyle(fontWeight: FontWeight.w600))),
              ...courses.map((course) => DataCell(
                    Wrap(
                      spacing: 4,
                      children: course.skills
                          .take(3)
                          .map((skill) => Chip(
                                label: Text(skill, style: const TextStyle(fontSize: 12)),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList()
                          .followedBy(course.skills.length > 3
                              ? [
                                  Chip(
                                    label: Text('+${course.skills.length - 3}',
                                        style: const TextStyle(fontSize: 12)),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  )
                                ]
                              : [])
                          .toList(),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRatingCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatLearningStyle(String style) {
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
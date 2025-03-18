import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/constants.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isInComparison;
  final VoidCallback onToggleComparison;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.course,
    required this.isInComparison,
    required this.onToggleComparison,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isInComparison 
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack for image and platform badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    course.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                // Platform badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPlatformColor(course.platformId),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      course.platformName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Price tag
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: course.price > 0 ? Colors.white : AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      course.getPriceText(),
                      style: TextStyle(
                        color: course.price > 0 ? Colors.black : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Instructor
                  Text(
                    course.instructor,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating
                  Row(
                    children: [
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatRatingCount(course.totalRatings)})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Level and duration
                  Row(
                    children: [
                      Icon(
                        _getLevelIcon(course.level),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _capitalizeFirstLetter(course.level),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.getDurationText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action buttons
            const Spacer(),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              buttonPadding: EdgeInsets.zero,
              children: [
                // Certificate indicator
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: course.hasCertificate
                      ? Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Certificate',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                
                // Compare button
                IconButton(
                  onPressed: onToggleComparison,
                  icon: Icon(
                    isInComparison
                        ? Icons.compare_arrows
                        : Icons.compare_arrows_outlined,
                    color: isInComparison ? AppColors.primary : Colors.grey[600],
                  ),
                  tooltip: isInComparison
                      ? 'Remove from comparison'
                      : 'Add to comparison',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
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

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'beginner':
        return Icons.speed_outlined;
      case 'intermediate':
        return Icons.trending_up;
      case 'advanced':
        return Icons.trending_up_outlined;
      default:
        return Icons.speed;
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getPlatformColor(String platformId) {
    switch (platformId) {
      case 'coursera':
        return const Color(0xFF0056D2); // Coursera blue
      case 'udemy':
        return const Color(0xFFA435F0); // Udemy purple
      case 'edx':
        return const Color(0xFF02262B); // edX dark teal
      case 'udacity':
        return const Color(0xFF01B3E3); // Udacity blue
      case 'skillshare':
        return const Color(0xFF00FF84); // Skillshare green
      case 'pluralsight':
        return const Color(0xFFF15B2A); // Pluralsight orange
      default:
        return AppColors.primary;
    }
  }
}
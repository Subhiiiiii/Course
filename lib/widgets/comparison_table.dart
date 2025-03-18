import 'package:flutter/material.dart';
import 'package:course_connext/utils/constants.dart';

class ComparisonTableRow extends StatelessWidget {
  final String title;
  final List<String> values;
  final bool isColored;
  final bool highlightBest;
  final bool bestIsCheapest;
  final bool isMultiline;
  
  const ComparisonTableRow({
    Key? key,
    required this.title,
    required this.values,
    this.isColored = false,
    this.highlightBest = false,
    this.bestIsCheapest = false,
    this.isMultiline = false,
  }) : super(key: key);

  int _getBestValueIndex() {
    if (!highlightBest) return -1;
    
    if (bestIsCheapest) {
      // For price, find the lowest non-zero price or "Free"
      int bestIdx = -1;
      double bestPrice = double.infinity;
      
      for (int i = 0; i < values.length; i++) {
        if (values[i] == 'Free') {
          return i;
        }
        
        final price = double.tryParse(values[i].replaceAll(RegExp(r'[^\d.]'), ''));
        if (price != null && price < bestPrice) {
          bestPrice = price;
          bestIdx = i;
        }
      }
      
      return bestIdx;
    } else {
      // For ratings, find the highest value
      int bestIdx = -1;
      double bestValue = -1;
      
      for (int i = 0; i < values.length; i++) {
        final value = double.tryParse(values[i].split(' ').first);
        if (value != null && value > bestValue) {
          bestValue = value;
          bestIdx = i;
        }
      }
      
      return bestIdx;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int bestValueIndex = _getBestValueIndex();
    
    return Container(
      color: isColored ? Colors.grey[100] : Colors.white,
      child: Row(
        children: [
          // Title cell
          Container(
            width: 120,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Value cells
          ...List.generate(values.length, (index) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: index < values.length - 1 
                        ? BorderSide(color: Colors.grey[300]!) 
                        : BorderSide.none,
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                  color: highlightBest && index == bestValueIndex
                      ? AppColors.primaryLight.withOpacity(0.2)
                      : null,
                ),
                child: isMultiline
                    ? Text(
                        values[index],
                        style: TextStyle(
                          fontWeight: highlightBest && index == bestValueIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: highlightBest && index == bestValueIndex
                              ? AppColors.primary
                              : null,
                        ),
                      )
                    : Center(
                        child: Text(
                          values[index],
                          style: TextStyle(
                            fontWeight: highlightBest && index == bestValueIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: highlightBest && index == bestValueIndex
                                ? AppColors.primary
                                : null,
                          ),
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

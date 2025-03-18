import 'package:flutter/material.dart';
import 'package:course_connext/utils/constants.dart';

class DurationFilter extends StatelessWidget {
  final int currentValue;
  final Function(int) onChanged;

  const DurationFilter({
    Key? key,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, size: 16),
              const SizedBox(width: 4),
              Text(
                'Duration: ${_getDurationText(currentValue)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey[300],
              trackHeight: 4.0,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withAlpha(32),
              valueIndicatorColor: AppColors.primary,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            child: Slider(
              min: 0,
              max: 24,
              divisions: 6,
              value: currentValue.toDouble(),
              label: _getDurationText(currentValue),
              onChanged: (value) => onChanged(value.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  String _getDurationText(int weeks) {
    if (weeks == 0) {
      return 'Any Duration';
    } else if (weeks == 1) {
      return '1 Week';
    } else if (weeks < 4) {
      return '$weeks Weeks';
    } else if (weeks == 4) {
      return '1 Month';
    } else if (weeks < 12) {
      final months = (weeks / 4).round();
      return '$months Months';
    } else {
      return '6+ Months';
    }
  }
}

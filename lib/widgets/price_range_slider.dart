import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PriceRangeSlider extends StatelessWidget {
  final double currentValue;
  final Function(double) onChanged;

  const PriceRangeSlider({
    Key? key,
    required this.currentValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  _getPriceRangeText(currentValue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              valueIndicatorColor: AppColors.primary,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: currentValue,
              min: 0,
              max: 500,
              divisions: 10,
              label: _getPriceRangeText(currentValue),
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Free'),
                const Text('\$50'),
                const Text('\$100'),
                const Text('\$200'),
                const Text('Any'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPriceRangeText(double value) {
    if (value == 0) {
      return 'Free';
    } else if (value >= 500) {
      return 'Any price';
    } else {
      return 'Under \$${value.toInt()}';
    }
  }
}
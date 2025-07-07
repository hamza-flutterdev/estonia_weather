import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WeatherIcon extends StatelessWidget {
  final dynamic weatherData;
  final String iconUrl;
  final double size;

  const WeatherIcon({
    super.key,
    required this.weatherData,
    required this.iconUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (weatherData != null && iconUrl.isNotEmpty) {
      return Image.network(
        iconUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: kWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          );
        },
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: kWhite.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.cloud,
        size: size * 0.6,
        color: kWhite.withValues(alpha: 0.7),
      ),
    );
  }
}

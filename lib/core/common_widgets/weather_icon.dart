import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
    return SizedBox(
      width: size,
      height: size,
      child:
          iconUrl.isNotEmpty
              ? FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                  iconUrl,
                  width: size * 0.8,
                  height: size * 0.8,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: size * 0.8,
                      height: size * 0.8,
                      decoration: BoxDecoration(
                        color: kWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
              : Container(
                decoration: BoxDecoration(
                  color: kWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.cloud,
                  size: size * 0.6,
                  color: kWhite.withValues(alpha: 0.7),
                ),
              ),
    );
  }
}

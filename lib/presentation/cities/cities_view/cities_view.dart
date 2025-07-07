import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constant.dart';
import '../controller/cities_controller.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        useBackButton: true,
        actions: [
          IconButton(
            onPressed: () => controller.saveAndGoBack(),
            icon: const Icon(Icons.add, color: primaryColor),
          ),
        ],
        subtitle: 'Manage Cities',
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              onChanged: (value) => controller.searchCities(value),
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          // Selected Cities List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.selectedCities.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No cities selected',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Search and add cities to get started',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.selectedCities.length,
                itemBuilder: (context, index) {
                  final city = controller.selectedCities[index];
                  final weather =
                      index < controller.citiesWeather.length
                          ? controller.citiesWeather[index]
                          : null;
                  final isMainCity = index == controller.mainCityIndex.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A90E2), Color(0xFF7B68EE)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // City Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // City Name with Location Icon
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            city.city,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        if (isMainCity) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Main',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Air Quality
                                    Text(
                                      weather != null
                                          ? 'Air quality ${weather.humidity}% • Good'
                                          : 'Air quality -- • Loading...',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Weather Condition
                                    Text(
                                      weather?.condition ?? 'Loading...',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Temperature
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    weather != null
                                        ? '${weather.temperature.round()}°'
                                        : '--°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Set as Main City Button
                              GestureDetector(
                                onTap: () => controller.setMainCity(index),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    isMainCity ? Icons.star : Icons.star_border,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              // Remove City Button
                              if (controller.selectedCities.length > 1) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap:
                                      () => controller.removeCityAtIndex(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Add Cities Section
          Obx(() {
            if (controller.filteredCities.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Available Cities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = controller.filteredCities[index];
                        final isSelected = controller.selectedCities.contains(
                          city,
                        );
                        final canAdd = controller.selectedCities.length < 10;

                        return ListTile(
                          leading: Icon(
                            Icons.location_city,
                            color:
                                isSelected
                                    ? const Color(0xFF4A90E2)
                                    : Colors.grey,
                          ),
                          title: Text(
                            city.city,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? const Color(0xFF4A90E2)
                                      : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            city.country,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF4A90E2),
                                  )
                                  : canAdd
                                  ? const Icon(Icons.add, color: Colors.grey)
                                  : Icon(
                                    Icons.block,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                          onTap: () {
                            if (!isSelected && canAdd) {
                              controller.toggleCitySelection(city);
                            } else if (isSelected) {
                              controller.toggleCitySelection(city);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

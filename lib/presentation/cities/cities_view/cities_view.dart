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
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        useBackButton: true,
        actions: [
          IconButton(
            onPressed: () => controller.saveAndGoBack(),
            icon: const Icon(Icons.check, color: primaryColor),
          ),
        ],
        subtitle: 'Manage Cities',
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(kBodyHp),
            padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => controller.searchCities(value),
              decoration: InputDecoration(
                hintText: 'Search cities...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: greyColor),
                hintStyle: bodyMediumStyle.copyWith(color: greyColor),
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
                        color: greyColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No cities selected',
                        style: titleMediumStyle.copyWith(color: greyColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Search and add cities to get started',
                        style: bodyMediumStyle.copyWith(color: greyColor),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                itemCount: controller.selectedCities.length,
                itemBuilder: (context, index) {
                  final city = controller.selectedCities[index];
                  final weather =
                      index < controller.citiesWeather.length
                          ? controller.citiesWeather[index]
                          : null;
                  final isMainCity = index == controller.mainCityIndex.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: kElementGap),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryColor, secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(kBodyHp),
                          child: Row(
                            children: [
                              // City Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: kWhite,
                                          size: secondaryIcon(context),
                                        ),
                                        const SizedBox(width: kElementWidthGap),
                                        Expanded(
                                          child: Text(
                                            city.city,
                                            style: titleBoldLargeStyle.copyWith(
                                              color: kWhite,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isMainCity) ...[
                                          const SizedBox(
                                            width: kElementWidthGap,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kWhite.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Main',
                                              style: bodySmallStyle.copyWith(
                                                color: kWhite,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: kElementInnerGap),
                                    Row(
                                      children: [
                                        Text(
                                          weather != null
                                              ? 'Humidity: ${weather.humidity}%'
                                              : 'Humidity: --',
                                          style: bodyMediumStyle.copyWith(
                                            color: kWhite,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          weather?.condition ?? 'Loading...',
                                          style: bodyMediumStyle.copyWith(
                                            color: kWhite,
                                          ),
                                        ),
                                      ],
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
                                    style: headlineLargeStyle.copyWith(
                                      color: kWhite,
                                    ),
                                  ),
                                  if (weather != null)
                                    Image.asset(
                                      controller.getWeatherIcon(
                                        weather.condition,
                                      ),
                                      width: primaryIcon(context),
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.cloud,
                                          color: kWhite,
                                          size: primaryIcon(context),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Set as Main City Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => controller.setMainCity(index),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isMainCity ? Icons.star : Icons.star_border,
                                color: kWhite,
                                size: secondaryIcon(context),
                              ),
                            ),
                          ),
                        ),
                        // Remove City Button
                        if (controller.selectedCities.length > 1)
                          Positioned(
                            top: 8,
                            right: 48,
                            child: GestureDetector(
                              onTap: () => controller.removeCityAtIndex(index),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: kWhite,
                                  size: secondaryIcon(context),
                                ),
                              ),
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
              height: 200,
              margin: const EdgeInsets.all(kBodyHp),
              decoration: BoxDecoration(
                color: kWhite,
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
                  Padding(
                    padding: const EdgeInsets.all(kBodyHp),
                    child: Text(
                      'Available Cities',
                      style: titleMediumStyle.copyWith(color: primaryColor),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                      itemCount: controller.filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = controller.filteredCities[index];
                        final isSelected = controller.selectedCities.contains(
                          city,
                        );

                        return ListTile(
                          leading: Icon(
                            Icons.location_city,
                            color: isSelected ? primaryColor : greyColor,
                          ),
                          title: Text(
                            city.city,
                            style: bodyMediumStyle.copyWith(
                              color: isSelected ? primaryColor : kWhite,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            city.city,
                            style: bodySmallStyle.copyWith(color: greyColor),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(Icons.check, color: primaryColor)
                                  : controller.selectedCities.length >= 10
                                  ? Icon(
                                    Icons.block,
                                    color: greyColor.withOpacity(0.5),
                                  )
                                  : const Icon(Icons.add, color: greyColor),
                          onTap: () {
                            if (!isSelected &&
                                controller.selectedCities.length < 10) {
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

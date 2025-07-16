import 'package:estonia_weather/core/animation/animated_weather_icon.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/common_widgets/custom_text_button.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_styles.dart';
import '../../../gen/assets.gen.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: Get.find<SplashController>(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.images.splash.path),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(kBodyHp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: kElementInnerGap),
                      AnimatedDefaultTextStyle(
                        style: headlineLargeStyle.copyWith(
                          color: controller.title.value,
                          fontFamily: fontSecondary,
                          fontSize: 75,
                        ),
                        duration: const Duration(milliseconds: 1500),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'ESTONIA\n'),
                              const TextSpan(text: 'weather'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: List.generate(
                            'Live Forecasts Across Estonia!'.length,
                            (index) {
                              final isVisible =
                                  index < controller.visibleLetters.value;
                              return TextSpan(
                                text: 'Live Forecasts Across Estonia!'[index],
                                style: titleSmallStyle.copyWith(
                                  color: isVisible ? primaryColor : transparent,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      AnimatedWeatherIcon(
                        imagePath: Assets.images.splashIcon.path,
                        condition: 'thunderstorm',
                        width: mobileHeight(context) * 0.3,
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 4,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: controller.loadingProgress.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: kElementInnerGap),
                          Text(
                            controller.loadingMessage.value,
                            style: bodyLargeStyle.copyWith(color: primaryColor),
                          ),
                          const SizedBox(height: kElementInnerGap),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: mobileHeight(context) * 0.1,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child:
                                  controller.showButton.value
                                      ? AnimatedOpacity(
                                        opacity:
                                            controller.showButton.value
                                                ? 1.0
                                                : 0.0,
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kBodyHp,
                                          ),
                                          child: CustomButton(
                                            width: mobileWidth(context) * 0.6,
                                            backgroundColor: primaryColor,
                                            textColor: kWhite,
                                            onPressed: () {
                                              Get.to(() => HomeView());
                                            },
                                            text: "Let's Go",
                                          ),
                                        ),
                                      )
                                      : LoadingAnimationWidget.fourRotatingDots(
                                        color: primaryColor,
                                        size: mobileWidth(context) * 0.2,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

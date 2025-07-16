import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/common_widgets/custom_text_button.dart';
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
                      const SizedBox(height: kBodyHp * 1.5),
                      AnimatedDefaultTextStyle(
                        style: headlineLargeStyle.copyWith(
                          color: controller.title.value,
                          fontFamily: fontSecondary,
                        ),
                        duration: const Duration(milliseconds: 1500),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'ESTONIA\n'),
                              const TextSpan(text: 'weather'),
                            ],
                          ),
                          textAlign:
                              TextAlign.center, // Center align both lines
                        ),
                      ),
                      const SizedBox(height: kElementInnerGap),
                      RichText(
                        text: TextSpan(
                          children: List.generate(
                            'Live Forecasts Across Estonia!'.length,
                            (index) {
                              final isVisible =
                                  index < controller.visibleLetters.value;
                              return TextSpan(
                                text: 'Live Forecasts Across Estonia!'[index],
                                style: headlineSmallStyle.copyWith(
                                  color: isVisible ? primaryColor : transparent,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: kElementInnerGap),
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
                          const SizedBox(height: kBodyHp),
                          Text(
                            controller.loadingMessage.value,
                            style: bodyLargeStyle.copyWith(color: primaryColor),
                          ),
                          const SizedBox(height: kBodyHp),
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

                          // if (controller.isDataLoaded.value)
                          //   ElevatedButton(
                          //     onPressed: controller.navigateToHome,
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.blue,
                          //       foregroundColor: const Color(0xFF1976D2),
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 32,
                          //         vertical: 16,
                          //       ),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(25),
                          //       ),
                          //     ),
                          //     child: const Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         Text(
                          //           'Get Started',
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w600,
                          //             color: kWhite,
                          //           ),
                          //         ),
                          //         SizedBox(width: 8),
                          //         Icon(Icons.arrow_forward, color: kWhite),
                          //       ],
                          //     ),
                          //   )
                          // else
                          //   const CircularProgressIndicator(
                          //     valueColor: AlwaysStoppedAnimation<Color>(
                          //       Colors.blue,
                          //     ),
                          //   ),
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

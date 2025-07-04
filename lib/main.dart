import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/binders/dependency_injection.dart';
import 'core/constants/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const EstoniaWeather());
}

class EstoniaWeather extends StatelessWidget {
  const EstoniaWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      title: 'Learn English',
      home: const HomeView(),
      theme: ThemeData(fontFamily: fontPrimary),
    );
  }
}

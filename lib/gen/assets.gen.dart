/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsDatabaseGen {
  const $AssetsDatabaseGen();

  /// File path: assets/database/cities.json
  String get cities => 'assets/database/cities.json';

  /// List of all assets
  List<String> get values => [cities];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/clear.png
  AssetGenImage get clear => const AssetGenImage('assets/images/clear.png');

  /// File path: assets/images/cloudy.png
  AssetGenImage get cloudy => const AssetGenImage('assets/images/cloudy.png');

  /// File path: assets/images/daily_forecast_bg_container.png
  AssetGenImage get dailyForecastBgContainer =>
      const AssetGenImage('assets/images/daily_forecast_bg_container.png');

  /// File path: assets/images/hourly_forecast_bg_container.png
  AssetGenImage get hourlyForecastBgContainer =>
      const AssetGenImage('assets/images/hourly_forecast_bg_container.png');

  /// File path: assets/images/humidity_droplet.png
  AssetGenImage get humidityDroplet =>
      const AssetGenImage('assets/images/humidity_droplet.png');

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// File path: assets/images/precipitation_umbrella.png
  AssetGenImage get precipitationUmbrella =>
      const AssetGenImage('assets/images/precipitation_umbrella.png');

  /// File path: assets/images/rain.png
  AssetGenImage get rain => const AssetGenImage('assets/images/rain.png');

  /// File path: assets/images/sleet.png
  AssetGenImage get sleet => const AssetGenImage('assets/images/sleet.png');

  /// File path: assets/images/snow.png
  AssetGenImage get snow => const AssetGenImage('assets/images/snow.png');

  /// File path: assets/images/thunderstorm.png
  AssetGenImage get thunderstorm =>
      const AssetGenImage('assets/images/thunderstorm.png');

  /// File path: assets/images/windy.png
  AssetGenImage get windy => const AssetGenImage('assets/images/windy.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    clear,
    cloudy,
    dailyForecastBgContainer,
    hourlyForecastBgContainer,
    humidityDroplet,
    icon,
    precipitationUmbrella,
    rain,
    sleet,
    snow,
    thunderstorm,
    windy,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsDatabaseGen database = $AssetsDatabaseGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

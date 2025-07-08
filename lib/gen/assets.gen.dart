/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/daily_forecast_bg_container.png
  AssetGenImage get dailyForecastBgContainer =>
      const AssetGenImage('assets/images/daily_forecast_bg_container.png');

  /// File path: assets/images/hourly_forecast_bg_container.png
  AssetGenImage get hourlyForecastBgContainer =>
      const AssetGenImage('assets/images/hourly_forecast_bg_container.png');

  /// File path: assets/images/humidity_droplet.png
  AssetGenImage get humidityDroplet =>
      const AssetGenImage('assets/images/humidity_droplet.png');

  /// File path: assets/images/precipitation_umbrella.png
  AssetGenImage get precipitationUmbrella =>
      const AssetGenImage('assets/images/precipitation_umbrella.png');

  /// File path: assets/images/windy.png
  AssetGenImage get windy => const AssetGenImage('assets/images/windy.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    dailyForecastBgContainer,
    hourlyForecastBgContainer,
    humidityDroplet,
    precipitationUmbrella,
    windy,
  ];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/cities.json
  String get cities => 'assets/json/cities.json';

  /// List of all assets
  List<String> get values => [cities];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
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

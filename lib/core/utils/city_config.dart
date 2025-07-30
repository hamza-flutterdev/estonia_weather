class CityConfig {
  static const List<String> priorityCities = ['tallinn', 'narva'];

  static const Map<String, String> accentMappings = {
    'àáâãäåæ': 'a',
    'èéêë': 'e',
    'ìíîï': 'i',
    'òóôõöø': 'o',
    'ùúûü': 'u',
    'ýÿ': 'y',
    'ñ': 'n',
    'ç': 'c',
    'š': 's',
    'ž': 'z',
    'ä': 'a',
    'ö': 'o',
    'ü': 'u',
  };

  static const int maxPaginationDots = 3;
  static const double cityCardWidthRatio = 0.7;
  static const double cityCardHeightRatio = 0.1;
  static const double paginationDotSizeRatio = 0.015;

  static String normalizeCityName(String cityName) {
    String normalized = cityName.toLowerCase().trim();

    accentMappings.forEach((pattern, replacement) {
      normalized = normalized.replaceAll(RegExp('[$pattern]'), replacement);
    });

    return normalized;
  }

  static bool cityNamesMatch(String name1, String name2) {
    return normalizeCityName(name1) == normalizeCityName(name2);
  }

  static bool isPriorityCity(String cityName) {
    return priorityCities.any((priority) => cityNamesMatch(cityName, priority));
  }

  static int getCityPriority(String cityName) {
    for (int i = 0; i < priorityCities.length; i++) {
      if (cityNamesMatch(cityName, priorityCities[i])) {
        return i;
      }
    }
    return -1;
  }
}

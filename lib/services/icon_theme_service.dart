import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class IconThemeService {
  static ColorFilter getColorFilterForTheme(AppIconTheme theme) {
    switch (theme) {
      case AppIconTheme.defaultTheme:
        return const ColorFilter.matrix([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);

      case AppIconTheme.dark:
        return const ColorFilter.matrix([
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);

      case AppIconTheme.fun:
        return const ColorFilter.matrix([
          1.4,
          -0.1,
          -0.1,
          0,
          10,
          -0.2,
          1.4,
          -0.1,
          0,
          10,
          -0.2,
          -0.1,
          1.2,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);

      case AppIconTheme.cute:
        return const ColorFilter.matrix([
          0.9,
          0.1,
          0.1,
          0,
          20,
          0.05,
          0.85,
          0.1,
          0,
          15,
          0.1,
          0.1,
          0.9,
          0,
          25,
          0,
          0,
          0,
          1,
          0,
        ]);
    }
  }

  static String getThemeName(AppIconTheme theme) {
    switch (theme) {
      case AppIconTheme.defaultTheme:
        return 'Default';
      case AppIconTheme.dark:
        return 'Dark';
      case AppIconTheme.fun:
        return 'Fun';
      case AppIconTheme.cute:
        return 'Cute';
    }
  }
}

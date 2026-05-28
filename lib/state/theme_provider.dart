import 'package:flutter/foundation.dart';
import '../core/app_colors.dart';

enum ColorMode { terra, slateEmber }

class ThemeProvider extends ChangeNotifier {
  ColorMode _mode = ColorMode.slateEmber;

  ColorMode get mode => _mode;
  AppColors get colors =>
      _mode == ColorMode.terra ? AppColors.terra : AppColors.slateEmber;
  bool get isLight => _mode == ColorMode.terra;

  void setMode(ColorMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void toggle() {
    _mode =
        _mode == ColorMode.terra ? ColorMode.slateEmber : ColorMode.terra;
    notifyListeners();
  }
}

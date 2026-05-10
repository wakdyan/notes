import 'package:flutter/material.dart';

extension ContextSize on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  double get maxWidth => _mediaQuery.size.width;

  double get maxHeight => _mediaQuery.size.height;
}

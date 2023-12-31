import 'dart:math';

import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double heightPercent(double percent) => height * percent / 100;
  double widthPercent(double percent) => width * percent / 100;
  double radius(double rd) =>
      sqrt(height * height + width * width) * (rd / 100);
}

import 'package:flutter/material.dart';

enum MetalType {
  gold,
  silver;

  String get displayName {
    switch (this) {
      case MetalType.gold:
        return 'Gold';
      case MetalType.silver:
        return 'Silver';
    }
  }

  Color get displayColor {
    switch (this) {
      case MetalType.gold:
        return const Color(0xFFFFD700);
      case MetalType.silver:
        return const Color(0xFFC0C0C0);
    }
  }
}

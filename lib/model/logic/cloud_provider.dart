import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/view/transition/illustration.dart';
import 'dart:ui';
import 'package:rnd/rnd.dart';
import 'dart:math'; // Import Dart's math library for random number generation


/// Cloud model class
class Cloud {
  final Offset pos;
  final double scale;
  final bool flipX;
  final bool flipY;
  final double opacity;
  final double size;

  Cloud({
    required this.pos,
    required this.scale,
    required this.flipX,
    required this.flipY,
    required this.opacity,
    required this.size,
  });
}

/// StateNotifier for managing clouds
class CloudNotifier extends StateNotifier<List<Cloud>> {
  CloudNotifier() : super([]);

  /// Generates clouds based on the WonderType
  void generateClouds(WonderType wonderType, double cloudSize, double opacity, Size screenSize) {
    final int seed = _getCloudSeed(wonderType);
    final rnd = Random(seed); // Simulate a random number generator based on a seed
    state = List.generate(3, (index) {
      return Cloud(
        pos: Offset(rnd.getDouble(-200, screenSize.width - 100),
            rnd.getDouble(50, screenSize.height - 50)),
        scale: rnd.getDouble(0.7, 1),
        flipX: rnd.getBool(),
        flipY: rnd.getBool(),
        opacity: opacity,
        size: cloudSize,
      );
    });
  }

  static int _getCloudSeed(WonderType type) {
    switch (type) {
      case WonderType.chichenItza:
        return 2;
      // case WonderType.christRedeemer:
      //   return 78;
      // case WonderType.colosseum:1ß
      //   return 1;
      // case WonderType.greatWall:
      //   return 500;
      // case WonderType.machuPicchu:
      //   return 37;
      // case WonderType.petra:
      //   return 111;
      // case WonderType.pyramidsGiza:
      //   return 15;
      // case WonderType.tajMahal:
        // return 2;
    }
  }
}

/// Cloud Provider
final cloudProvider = StateNotifierProvider<CloudNotifier, List<Cloud>>(
  (ref) => CloudNotifier(),
);

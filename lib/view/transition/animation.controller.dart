import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationControllerNotifier extends StateNotifier<AnimationController?> {
  AnimationControllerNotifier(TickerProvider vsync)
      : super(AnimationController(vsync: vsync, duration: const Duration(milliseconds: 750)));

  void forward() {
    state?.forward(from: 0);
  }

  void reverse() {
    state?.reverse(from: 1);
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

final animationControllerProvider = StateNotifierProvider<AnimationControllerNotifier, AnimationController?>((ref) {
  throw UnimplementedError(); // This will be initialized in the widget.
});
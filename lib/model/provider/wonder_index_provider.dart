import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage _wonderIndex
class WonderIndexNotifier extends StateNotifier<int> {
  WonderIndexNotifier() : super(0); // Initial wonder index is 0

  void setWonderIndex(int index) {
    state = index;
  }
}

final wonderIndexProvider = StateNotifierProvider<WonderIndexNotifier, int>(
  (ref) => WonderIndexNotifier(),
);

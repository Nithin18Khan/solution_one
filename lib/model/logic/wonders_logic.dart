// WondersLogic StateNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/first_page.dart';
import 'package:solution_one/model/data_model.dart';
import 'package:solution_one/view/transition/illustration.dart';
import 'package:collection/collection.dart';


class WondersLogicNotifier extends StateNotifier<List<WonderData>> {
  WondersLogicNotifier() : super([]) {
    _init();
  }

  final int timelineStartYear = -3000;
  final int timelineEndYear = 2200;

  // Initialize the wonders list
  void _init() {
    state = [
      // GreatWallData(),
      // PetraData(),
      // ColosseumData(),
      ChichenItzaData(),
      // MachuPicchuData(),
      // TajMahalData(),
      // ChristRedeemerData(),
      // PyramidsGizaData(),
    ];
  }

  // Get specific WonderData by type
  WonderData getData(WonderType value) {
    final result = state.firstWhereOrNull((w) => w.type == value);
    if (result == null) throw ('Could not find data for wonder type $value');
    return result;
  }
}


final wondersProvider =
    StateNotifierProvider<WondersLogicNotifier, List<WonderData>>(
  (ref) => WondersLogicNotifier(),
);


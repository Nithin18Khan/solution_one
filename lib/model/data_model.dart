import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:solution_one/view/transition/illustration.dart';

class WonderData extends Equatable {
  const WonderData({
    required this.type,
    required this.title,
  });

  final WonderType type;
  final String title;

  @override
  List<Object?> get props => [type, title];
}

class WonderDataNotifier extends StateNotifier<WonderData> {
  WonderDataNotifier(WonderData state) : super(state);

  // You can add methods to update the state here
  void updateWonderType(WonderType newType) {
    state = WonderData(type: newType, title: state.title);
  }

  void updateTitle(String newTitle) {
    state = WonderData(type: state.type, title: newTitle);
  }
}
final wonderDataProvider = StateNotifierProvider<WonderDataNotifier, WonderData>((ref) {
  // Initialize the WonderData with a default value
  return WonderDataNotifier(WonderData(type: WonderType.chichenItza, title:""));
});

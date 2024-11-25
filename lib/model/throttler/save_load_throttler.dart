import 'package:flutter/foundation.dart';
import 'package:solution_one/model/throttler/json_prefs.dart';
import 'package:solution_one/model/throttler/throttler.dart';


mixin ThrottledSaveLoadMixin {
  late final _file = JsonPrefsFile(fileName);
  final _throttle = Throttler(const Duration(seconds: 2));

  Future<void> load() async {
    final results = await _file.load();
    try {
      copyFromJson(results);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> save() async {
    debugPrint('Saving...');
    try {
      await _file.save(toJson());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> scheduleSave() async => _throttle.call(save);

  /// Serialization
  String get fileName;
  Map<String, dynamic> toJson();
  void copyFromJson(Map<String, dynamic> value);
}

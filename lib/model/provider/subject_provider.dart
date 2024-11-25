import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/subject.model.dart';
import 'package:solution_one/model/logic/subject.service.dart';


// SubjectNotifier: Manages the state
class SubjectNotifier extends StateNotifier<AsyncValue<List<Subject>>> {
  final SubjectService _service;

  SubjectNotifier(this._service) : super(const AsyncValue.loading());

  /// Fetch subjects and update the state
  Future<void> fetchSubjects() async {
    try {
      final subjects = await _service.fetchSubjects();
      state = AsyncValue.data(subjects);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Provider to expose SubjectNotifier
final subjectProvider = StateNotifierProvider<SubjectNotifier, AsyncValue<List<Subject>>>(
  (ref) => SubjectNotifier(SubjectService()),
);

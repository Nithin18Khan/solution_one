import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/module.dart';
import 'package:solution_one/model/logic/module_service.dart';


// Create a provider for modules
final moduleProvider = FutureProvider.family<List<Module>, int>((ref, subjectId) async {
  final moduleService = ModuleService();
  return await moduleService.fetchModules(subjectId);
});

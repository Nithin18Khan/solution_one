import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/module.dart';
import 'package:solution_one/model/provider/module_provider.dart';
import 'package:solution_one/view/screen/module_video_screen.dart';

class ModuleListScreen extends ConsumerWidget {
  final int subjectId;

  // Constructor to accept subjectId
  ModuleListScreen({required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleState = ref.watch(moduleProvider(subjectId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
        backgroundColor: Colors.deepPurple,
      ),
      body: moduleState.when(
        // Loading State: Show a progress indicator while data is loading
        loading: () => Center(child: CircularProgressIndicator()),
        
        // Error State: Display a friendly error message
        error: (error, stack) => Center(child: Text("Something went wrong: $error")),
        
        // Data State: Display the list of modules
        data: (modules) => modules.isEmpty
            ? Center(child: Text('No modules available'))
            : ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  Module module = modules[index];
                  return _buildModuleCard(module, context);
                },
              ),
      ),
    );
  }

  // Method to build a card for each module
  Widget _buildModuleCard(Module module, BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          module.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Text(
          module.description,
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.deepPurple,
        ),
        onTap: () {
          // Handle tap, can navigate to another screen or show a detail modal
          _onModuleTap(context, module);
        },
      ),
    );
  }

  // Method to handle module tap (you can implement navigation here)
  void _onModuleTap(BuildContext context, Module module) {
    // Example of navigation to a detail screen (you can modify this based on your app's structure)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoListScreen(moduleId: module.id)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on: ${module.name}')),
    );
  }
}

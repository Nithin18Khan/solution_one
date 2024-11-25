import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/subject.model.dart';
import 'package:solution_one/model/provider/subject_provider.dart';
import 'package:solution_one/view/screen/module_screen.dart';

class SubjectScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectState = ref.watch(subjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects"),
        backgroundColor: Colors.deepPurple,
      ),
      body: subjectState.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return Center(
              child: Text(
                "No subjects available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 600;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWideScreen ? 3 : 1,
                  childAspectRatio: isWideScreen ? 1.5 : 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                padding: const EdgeInsets.all(16.0),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  Subject subject = subjects[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ModuleListScreen(subjectId: subject.id),
                        ),
                      );
                    },
                    child: _buildAnimatedCard(subject),
                  );
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            "Error: $error",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => ref.read(subjectProvider.notifier).fetchSubjects(),
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildAnimatedCard(Subject subject) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                subject.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subject.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.deepPurple[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

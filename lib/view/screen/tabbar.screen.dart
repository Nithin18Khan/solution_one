import 'package:flutter/material.dart';
import 'package:solution_one/view/screen/subjectt_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
     SubjectScreen(),
    const Center(child: Text("Search Screen")),
    const Center(child: Text("Profile Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Player',
          ),
        ],
      ),
    );
  }
}

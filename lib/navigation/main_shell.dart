import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/categories/category_page.dart';
import '../features/projects/projects_page.dart';
import '../features/tasks/tasks_page.dart';
import '../features/schedule/schedule_page.dart';
import '../features/archive/archive_page.dart';
import 'sidebar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int page = 0;

  String? categoryId;
  String? categoryName;

  void openCategory(Map<String, dynamic> category) {
    setState(() {
      categoryId = category['id'].toString();
      categoryName = category['name'].toString();
      page = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;

    final pages = [
      HomePage(onCategory: openCategory),
      CategoryPage(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
      const ProjectsPage(),
      const TasksPage(),
      const SchedulePage(),
      const ArchivePage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          if (wide)
            Sidebar(
              page: page,
              onSelect: (v) {
                setState(() {
                  page = v;
                });
              },
              onCategory: openCategory,
            ),
          Expanded(child: pages[page]),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: page > 4 ? 0 : page,
              onDestinationSelected: (v) {
                setState(() {
                  page = v;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Icon(Icons.layers_outlined),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.check_box_outlined),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'Schedule',
                ),
              ],
            ),
    );
  }
}
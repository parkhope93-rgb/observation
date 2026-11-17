import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/database/supabase_client.dart';
import '../core/utils/helpers.dart';
import '../shared/dialogs/category_dialog.dart';

class Sidebar extends StatelessWidget {
  final int page;
  final ValueChanged<int> onSelect;
  final ValueChanged<Map<String, dynamic>> onCategory;

  const Sidebar({
    super.key,
    required this.page,
    required this.onSelect,
    required this.onCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 238,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 28, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.all_inclusive, color: forest, size: 28),
              SizedBox(width: 9),
              Text(
                'Observatory',
                style: TextStyle(
                  color: forest,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),

          _nav('Home', Icons.home_outlined, 0),
          _nav('Categories', Icons.folder_outlined, 1),
          _nav('Projects', Icons.layers_outlined, 2),
          _nav('Tasks', Icons.check_box_outlined, 3),
          _nav('Calendar', Icons.calendar_month_outlined, 4),
          _nav('Archive', Icons.inventory_2_outlined, 5),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(color: Color(0xFFECEFE9)),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CATEGORIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: forest,
                ),
              ),
              IconButton(
                onPressed: () => showCategoryDialog(context),
                icon: const Icon(Icons.add, color: forest),
              ),
            ],
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: db.from('categories').select().order('name'),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('카테고리를 불러오지 못했어.'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.map((category) {
                    return ListTile(
                      dense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8),
                      leading: CircleAvatar(
                        radius: 6,
                        backgroundColor: catColor(category['color']),
                      ),
                      title: Text(category['name']),
                      onTap: () => onCategory(category),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _nav(String title, IconData icon, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        selected: page == index,
        selectedTileColor: selectedBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: forest),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: () => onSelect(index),
      ),
    );
  }
}
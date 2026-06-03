import 'package:flutter/material.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

final api = ApiService();

class SelectCategoryWidget extends StatefulWidget {
  final String userId;

  SelectCategoryWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _SelectCategoryWidgetState createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  List<Category> categories = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await api.getCategoriesByUser(widget.userId);
      if (data != null) {
        categories = data.map<Category>((json) {
          final mapJson = Map<String, dynamic>.from(json);
          return Category.fromJson(mapJson, userId: widget.userId);
        }).toList();
      } else {
        categories = [];
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text('Lỗi: $error'));
    }

    if (categories.isEmpty) {
      return const Center(child: Text('Không có danh mục nào.'));
    }

    return Container(
      height: 250, // giới hạn chiều cao, thay đổi tuỳ ý
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return ListTile(
            leading: cat.iconId != null
                ? Image.asset(cat.iconId!, width: 32, height: 32)
                : const Icon(Icons.category),
            title: Text(cat.name ?? 'Không tên'),
            subtitle: Text(cat.type ?? ''),
            onTap: () {
              // Xử lý chọn category nếu cần
              print('Chọn danh mục: ${cat.name}');
            },
          );
        },
      ),
    );
  }
}

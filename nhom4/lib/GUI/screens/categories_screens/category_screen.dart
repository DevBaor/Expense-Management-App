import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'add_category.dart';

final api = ApiService();

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  String? _catError;
  bool _isCatLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _catError = 'Chưa đăng nhập';
        _isCatLoading = false;
      });
      return;
    }

    setState(() {
      _isCatLoading = true;
      _catError = '';
    });

    try {
      final data = await api.getCategoriesByUser(userId);
      if (data != null) {
        _categories =
            data.map<Category>((json) {
              final mapJson = Map<String, dynamic>.from(json);
              final category = Category.fromJson(mapJson, userId: userId);
              print("Loaded Category: $category");
              return category;
            }).toList();
      } else {
        _categories = [];
      }
    } catch (e) {
      setState(() {
        _catError = e.toString();
      });
    } finally {
      setState(() {
        _isCatLoading = false;
        print("Loading finished: _isCatLoading = $_isCatLoading");
        print("Categories count: ${_categories.length}");
        print("Error: $_catError");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C2526), // Dark background
              Color(0xFF2D3338), // Slightly lighter shade
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Danh sách loại",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCategoryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Category list or error/loading
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadCategories,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF2D3338),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: Builder(
                        builder: (context) {
                          print(
                            "Evaluating UI state: _isCatLoading = $_isCatLoading, _catError = $_catError, _categories.length = ${_categories.length}",
                          ); // Debug
                          if (_isCatLoading) {
                            print("Showing loading indicator");
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          if (_catError != null && _catError!.isNotEmpty) {
                            return Center(
                              child: Text(
                                _catError!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }

                          if (_categories.isEmpty) {
                            print("Showing empty state");
                            return const Center(
                              child: Text(
                                "Không có loại nào.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }
                          print(
                            "===============================================",
                          );
                          print(
                            "Rendering ListView.builder with ${_categories.length} items",
                          );
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              print("Building item $index: ${category.name}");
                              return _buildCategoryItem(
                                context,
                                iconId: category.iconId ?? '',
                                name: category.name ?? 'Loại không tên',
                                type: category.type ?? 'expense'
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required String iconId,
    required String name,
    required String type, // thêm tham số type
  }) {
    Color textColor;
    if (type.toLowerCase() == 'expense') {
      textColor = Colors.redAccent;
    } else if (type.toLowerCase() == 'income') {
      textColor = Colors.greenAccent;
    } else {
      textColor = Colors.white;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: const Color(0xFF2D3338),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: SuperIcon(iconPath: iconId, size: 24),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Navigate to category details or edit screen if needed
        },
      ),
    );
  }
  
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/BudgetModel.dart';
import 'package:nhom4/GUI/screens/budget_screens/add_budget_screen.dart';
import 'package:nhom4/core/model/super_icon_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final ApiService apiService = ApiService();
  final _userId = FirebaseAuth.instance.currentUser?.uid;
  bool _isLoading = false;
  String? _errorMessage;
  List<Budget> _budgets = [];

  @override
  void initState() {
    super.initState();
    _fetchBudgets();
  }

  Future<void> _fetchBudgets() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Chưa đăng nhập';
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final data = await apiService.getBudgetsByUser(userId);
      if (!mounted) return;
      final List<Budget> budgets = (data as List<dynamic>)
          .map((item) => Budget.fromJson(item as Map<String, dynamic>, _userId!))
          .toList();

      if (!mounted) return;
      setState(() {
        _budgets = budgets;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Lỗi khi tải ngân sách: $e';
        print('Lỗi khi tải ngân sách: $e');
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Không có ngày';
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2526),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3338),
        title: const Text('Danh sách ngân sách'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "budget_add_btn",
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBudgetScreen()),
          );
          if (!mounted) return;
          if (result == true) {
            _fetchBudgets();
          }
        },
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.add),
        label: const Text("Thêm ngân sách"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchBudgets,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  child: _budgets.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height -
                                kToolbarHeight -
                                100,
                            child: const Text(
                              "Bạn chưa tạo ngân sách nào.\nHãy bắt đầu bằng cách thêm ngân sách mới!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _budgets.length,
                          itemBuilder: (context, index) {
                            final budget = _budgets[index];
                            return Card(
                              color: const Color(0xFF2D3338),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: FutureBuilder<String>(
                                  future: get_iconCategory(budget.categoryId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError || !snapshot.hasData) {
                                      return const SuperIcon(iconPath: 'debt.svg', size: 32);
                                    } else {
                                      return SuperIcon(iconPath: snapshot.data!, size: 32);
                                    }
                                  },
                                ),
                                title: Text(
                                  budget.label ?? 'Không tên',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "Từ ${formatDate(budget.beginDate)} đến ${formatDate(budget.endDate)}\n"
                                  "Số tiền: ${budget.amount?.toStringAsFixed(0) ?? '0'}đ - Đã chi: ${budget.spent?.toStringAsFixed(0) ?? '0'}đ",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Icon(
                                  budget.isFinished == 1
                                      ? Icons.check_circle
                                      : Icons.access_time,
                                  color: budget.isFinished == 1 ? Colors.green : Colors.orange,
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: const Color(0xFF2D3338),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    builder: (BuildContext bottomSheetContext) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.edit, color: Colors.amber),
                                            title: const Text('Chỉnh sửa ngân sách',
                                                style: TextStyle(color: Colors.white)),
                                            onTap: () {
                                              Navigator.pop(bottomSheetContext);
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Dạ thầy ơi em làm chưa kịp ạ"),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete, color: Colors.redAccent),
                                            title: const Text('Xóa ngân sách',
                                                style: TextStyle(color: Colors.white)),
                                            onTap: () async {
                                              Navigator.pop(bottomSheetContext);

                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text("Xác nhận xóa"),
                                                  content: const Text("Bạn có chắc muốn xóa ngân sách này không?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx, false),
                                                      child: const Text("Hủy"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx, true),
                                                      child: const Text("Xóa",
                                                          style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true && mounted) {
                                                try {
                                                  await apiService.deleteBudget(budget.id!);
                                                  if (!mounted) return;
                                                  await _fetchBudgets();

                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("Đã xóa ngân sách")),
                                                    );
                                                  }
                                                } catch (e) {
                                                  if (mounted) {
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
    );
  }

  Future<String> get_iconCategory(String id) async {
    try {
      final response = await api.getCategory(id);
      if (response != null && response['icon_id'] != null) {
        return response['icon_id'] as String;
      } else {
        return 'debt.svg';
      }
    } catch (e) {
      print('Error fetching icon for category $id: $e');
      return 'debt.svg';
    }
  }
}

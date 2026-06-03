import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/core/model/super_icon_model.dart';

final api = ApiService();

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  String? _selectedCategoryId;
  double? _amount;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _userId = FirebaseAuth.instance.currentUser?.uid;
  String? _budgetName;
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (_userId == null) return;
    try {
      final data = await api.getCategoriesByUser(_userId!);
      if (data != null) {
        setState(() {
          _categories =
              data
                  .map<Category>(
                    (json) => Category.fromJson(
                      Map<String, dynamic>.from(json),
                      userId: _userId!,
                    ),
                  )
                  .toList();
        });
      }
    } catch (e) {
      print("Error loading categories: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDate({
    required DateTime? initialDate,
    required Function(DateTime) onDatePicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Color(0xFF2A2A2A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDatePicked(picked);
    }
  }

  void _submitBudget() async {
    if (_selectedCategoryId != null &&
        _amount != null &&
        _amount! > 0 &&
        _startDate != null &&
        _endDate != null &&
        _startDate!.isBefore(_endDate!)) {
      final uuid = Uuid();
      final newBudget = {
        "id": uuid.v4(),
        "user_id": _userId,
        "category_id": _selectedCategoryId,
        "amount": _amount,
        "begin_date": _startDate!.toIso8601String(),
        "end_date": _endDate!.toIso8601String(),
        "label": _budgetName,
        "spent": 0
      };

    // Lấy tất cả ngân sách của người dùng
final existingBudgets = await api.getBudgetsByUser(_userId!);

// Kiểm tra nếu đã tồn tại ngân sách chưa hoàn thành cùng nhóm
final alreadyExists = existingBudgets.any((budget) =>
  budget['category_id'] == _selectedCategoryId &&
  budget['is_finished'] == 0
);

if (alreadyExists) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Bạn đã tạo ngân sách cho nhóm này rồi!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
  );
  return;
}


      await api.createBudget(newBudget);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thêm ngân sách thành công!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng nhập đầy đủ thông tin hợp lệ!\n(Ngày bắt đầu phải trước ngày kết thúc)',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Thêm Ngân Sách',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: const Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Tên ngân sách',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _budgetName = value;
                          },
                        ),
                        trailing: const Icon(
                          Icons.title,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Nhóm
                      ListTile(
                        tileColor: const Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          _selectedCategoryId == null
                              ? 'Chọn nhóm'
                              : _categories
                                      .firstWhere(
                                        (cat) => cat.id == _selectedCategoryId,
                                      )
                                      .name ??
                                  '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF1A1A1A),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) {
                              return ListView(
                                children:
                                    _categories.map((category) {
                                      return ListTile(
                                        leading: SuperIcon(
                                          iconPath: category.iconId!,
                                          size: 24,
                                        ),
                                        title: Text(
                                          category.name ?? 'Không tên',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedCategoryId = category.id;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Số tiền
                      ListTile(
                        tileColor: const Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Số tiền ngân sách',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _amount = double.tryParse(value);
                          },
                        ),
                        trailing: const Icon(
                          Icons.monetization_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Ngày bắt đầu
                      ListTile(
                        tileColor: const Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          _startDate == null
                              ? 'Chọn ngày bắt đầu'
                              : 'Ngày bắt đầu: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onTap:
                            () => _pickDate(
                              initialDate: _startDate,
                              onDatePicked:
                                  (date) => setState(() => _startDate = date),
                            ),
                      ),

                      const SizedBox(height: 12),

                      /// Ngày kết thúc
                      ListTile(
                        tileColor: const Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          _endDate == null
                              ? 'Chọn ngày kết thúc'
                              : 'Ngày kết thúc: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onTap:
                            () => _pickDate(
                              initialDate: _endDate,
                              onDatePicked:
                                  (date) => setState(() => _endDate = date),
                            ),
                      ),

                      const SizedBox(height: 30),

                      /// Nút Thêm
                      ElevatedButton(
                        onPressed: _submitBudget,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Thêm',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

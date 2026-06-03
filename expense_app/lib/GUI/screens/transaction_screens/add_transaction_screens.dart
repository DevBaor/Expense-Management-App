import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:nhom4/GUI/screens/introduction_screens/first_wallet_screen.dart';
import 'package:nhom4/core/model/wallet_model.dart';
import 'package:nhom4/GUI/screens/home_screen/home_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/core/model/EventModel.dart';

final api = ApiService();

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  Category? _selectedCategory;
  String _selectedWallet = '';
  String _selectedWalletId = '';
  DateTime _selectedDate = DateTime.now();
  String _note = '';
  bool _isEditingNote = false;
  bool _showMoreOptions = false;
  List<Category> _categories = [];
  bool _isCatLoading = false;
  bool _isWalletLoading = false;
  String _catError = '';
  List<Wallet> _wallets = [];
  bool _isEventLoading = false;
  String? _selectedEventName;
  String? _selectedEventId;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    getcurrent_wallet();
    getListWallet();
  }

  void _showCategoryPickers() {
    if (_isCatLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đang tải danh mục...')));
      return;
    }
    if (_categories.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không có danh mục nào')));
      return;
    }
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn nhóm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];

                      // Xác định màu theo type
                      Color textColor;
                      if (category.type == 'expense') {
                        textColor = Colors.red;
                      } else if (category.type == 'income') {
                        textColor = Colors.green;
                      } else {
                        textColor = Colors.black;
                      }

                      return ListTile(
                        leading: SuperIcon(
                          iconPath: category.iconId!,
                          size: 24,
                        ),
                        title: Text(
                          category.name ?? '',
                          style: TextStyle(color: textColor),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _selectedCategory = category);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _loadCategories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _catError = 'Chưa đăng nhập');
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
              return Category.fromJson(mapJson, userId: userId);
            }).toList();
      } else {
        _categories = [];
      }
    } catch (e) {
      _catError = e.toString();
    } finally {
      setState(() => _isCatLoading = false);
    }
  }

  void _showEventPickers() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final List<dynamic> rawData = await api.getEventsByUser(userId ?? "");
    _events = rawData.map((e) => Event.fromJson(e)).toList();
    if (_isEventLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đang tải sự kiện...')));
      return;
    }

    if (_events.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không có sự kiện nào')));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn sự kiện',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return ListTile(
                        leading: SuperIcon(iconPath: event.iconPath!, size: 24),
                        title: Text(event.name ?? ''),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedEventName = event.name ?? '';
                            _selectedEventId = event.id ?? '';
                            print(
                              '=================================================',
                            );
                            print("sự kiện : ");
                            print(_selectedEventName);
                            print(_selectedEventId);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Icon(icon, color: Colors.amber),
    title: Text(
      label,
      style: TextStyle(color: Colors.white, fontFamily: Style.fontFamily),
    ),
    subtitle:
        value != null && value.isNotEmpty
            ? Text(
              value,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: Style.fontFamily,
              ),
            )
            : null,
    trailing: Icon(Icons.chevron_right, color: Colors.white),
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.boxBackgroundColor2,
        elevation: 0,
        title: Text(
          'Tạo giao dịch',
          style: TextStyle(fontFamily: Style.fontFamily),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text("❌", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 28, color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.monetization_on, color: Colors.amber),
              hintText: 'Nhập số tiền',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 16),
          _buildTile(
            icon: Icons.category,
            label: 'Chọn nhóm',
            value: _selectedCategory?.name,
            onTap: _showCategoryPickers,
          ),
          _buildTile(
            icon: Icons.account_balance_wallet,
            label: _selectedWallet,
            onTap: _showWalletPickers,
          ),
          _buildTile(
            icon: Icons.calendar_today,
            label: 'Date',
            value: DateFormat.yMMMd().format(_selectedDate),
            onTap: _pickDate,
          ),
          _isEditingNote
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _noteController,
                  autofocus: true,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) {
                    setState(() {
                      _note = text;
                      _isEditingNote = false;
                    });
                  },
                ),
              )
              : _buildTile(
                icon: Icons.notes,
                label: 'Write note',
                value: _note,
                onTap: () {
                  setState(() {
                    _isEditingNote = true;
                    _noteController.text = _note;
                  });
                },
              ),
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showMoreOptions = !_showMoreOptions;
                    });
                  },
                  child: Text(
                    _showMoreOptions ? "Ẩn bớt ▲" : "Thêm lựa chọn ▼",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_showMoreOptions) ...[
                  _buildTile(
                    icon: Icons.event,
                    label: 'Chọn sự kiện',
                    onTap: () {
                      _showEventPickers();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      controller: _contactController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.contact_page,
                          color: Colors.amber,
                        ),
                        hintText: 'Nhập tên liên hệ',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _saveTransaction,
                  icon: Icon(Icons.check),
                  label: Text("Lưu giao dịch"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTransaction() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final uuid = Uuid();
    String newId = uuid.v4();

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Chưa đăng nhập')));
      return;
    }

    if (_amountController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedWalletId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')));
      return;
    }

    // Parse số tiền
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Số tiền không hợp lệ')));
      return;
    }

    // Nếu có chọn sự kiện nhưng ID rỗng
    if (_selectedEventName != null && _selectedEventId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sự kiện không hợp lệ')));
      return;
    }

    // Tạo đối tượng giao dịch

    final transaction = {
      'id': newId,
      'user_id': userId,
      'amount': amount,
      'category_id': _selectedCategory!.id,
      'wallet_id': _selectedWalletId,
      'date': _selectedDate.toIso8601String(),
      'note': _noteController.text,
      if (_contactController.text != null) 'contact': _contactController.text,
      if (_selectedEventId != null) 'event_id': _selectedEventId,
    };
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'số tiền không được âm!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await api.createTransaction(transaction);

      // Nếu là chi tiêu => trừ tiền ví
      if (_selectedCategory!.type == 'expense') {
        final data = await api.getWalletById(_selectedWalletId);
        final W = Wallet.fromJson(data, FirebaseAuth.instance.currentUser!.uid);

        print(W);
        await api.updateWallet(_selectedWalletId, {
          'amount': W.amount - amount,
        });
        if (_selectedEventId != null) {
          final datas = await api.getEvent(_selectedEventId ?? "");
          final Ev = Event.fromJson(datas);
          await api.updateEvent(_selectedEventId ?? "", {
            'spent': Ev.spent! - amount,
          });
        }
      }
      if (_selectedCategory!.type == 'income') {
        final data = await api.getWalletById(_selectedWalletId);
        final W = Wallet.fromJson(data, FirebaseAuth.instance.currentUser!.uid);

        print(W);
        await api.updateWallet(_selectedWalletId, {
          'amount': W.amount + amount,
        });
        if (_selectedEventId != null) {
          final datas = await api.getEvent(_selectedEventId ?? "");
          final Ev = Event.fromJson(datas);
          await api.updateEvent(_selectedEventId ?? "", {
            'spent': Ev.spent! + amount,
          });
        }
      }
      final allBudgets = await api.getBudgetsByUser(userId);
      final matchingBudget = allBudgets.firstWhere(
        (b) =>
            b['category_id'] == _selectedCategory!.id &&
            b['is_finished'] == 0 &&
            DateTime.parse(b['begin_date']).isBefore(_selectedDate) &&
            DateTime.parse(b['end_date']).isAfter(_selectedDate),
        orElse: () => null,
      );
      print("hú hú =========================================================");
      print(matchingBudget);
      if (matchingBudget != null) {
        final spent = double.tryParse(matchingBudget['spent'].toString()) ?? 0;
        final amountBudget =
            double.tryParse(matchingBudget['amount'].toString()) ?? 0;

        final newSpent = spent + amount;
        final isFinished = newSpent >= amountBudget ? 1 : 0;

        try {
          await api.updateBudget(matchingBudget['id'], {
            'spent': newSpent,
            'is_finished': isFinished,
          });
          if (isFinished == 1) {
            // Hiển thị cảnh báo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Bạn đã vượt quá ngân sách cho nhóm này!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          print('Lỗi khi cập nhật budget: $e');
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Giao dịch đã được lưu')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lưu giao dịch: $e')));
    }
  }

  Future<String> getcurrent_wallet() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _catError = 'Chưa đăng nhập');
      return '';
    }
    final data = await api.getWalletsByUser(userId);
    if (data != null) {
      _selectedWallet = data.first['name'];
    } else {
      _selectedWallet = '';
    }
    return _selectedWallet;
  }

  Future<void> getListWallet() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _catError = 'Chưa đăng nhập');
      return;
    }
    final data = await api.getWalletsByUser(userId);
    if (data != null) {
      _wallets = data.map((e) => Wallet.fromJson(e, userId)).toList();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstWalletScreen()),
      );
    }
  }

  void _showWalletPickers() {
    if (_isWalletLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đang tải danh sách ví...')));
      return;
    }
    if (_wallets.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không có ví nào')));
      return;
    }
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn ví',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _wallets.length,
                    itemBuilder: (context, index) {
                      final wallet = _wallets[index];
                      return ListTile(
                        leading: SuperIcon(
                          iconPath: wallet.iconId ?? '',
                          size: 24,
                        ),
                        title: Text(wallet.name ?? ''),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedWallet = wallet.name ?? '';
                            _selectedWalletId = wallet.id ?? '';
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

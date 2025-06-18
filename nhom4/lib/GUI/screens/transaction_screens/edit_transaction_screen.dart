import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/TransactionModel.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:nhom4/core/model/wallet_model.dart';
import 'package:nhom4/core/model/EventModel.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:nhom4/GUI/style.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  EditTransactionScreen({required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final api = ApiService();

  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _contactController;

  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _isCatLoading = false;
  String _catError = '';

  String _selectedWallet = '';
  String _selectedWalletId = '';
  List<Wallet> _wallets = [];

  DateTime _selectedDate = DateTime.now();
  String _note = '';
  bool _isEditingNote = false;
  bool _showMoreOptions = false;

  List<Event> _events = [];
  bool _isEventLoading = false;
  String? _selectedEventName;
  String? _selectedEventId;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;

    _amountController = TextEditingController(text: tx.amount?.toString() ?? '');
    _noteController = TextEditingController(text: tx.note ?? '');
    _contactController = TextEditingController(text: tx.contact ?? '');
    _selectedDate = tx.date ?? DateTime.now();
    _selectedEventId = tx.eventId;

    _loadCategories();
    _loadEvents();
    getListWallet();
  }

  Future<void> _loadCategories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isCatLoading = true);
    try {
      final data = await api.getCategoriesByUser(userId);
      _categories = data!.map<Category>((json) {
        final mapJson = Map<String, dynamic>.from(json);
        return Category.fromJson(mapJson, userId: userId);
      }).toList();

      setState(() {
        _selectedCategory = _categories.firstWhere(
          (c) => c.id == widget.transaction.categoryId,
          orElse: () => _categories.first,
        );
      });
    } catch (e) {
      _catError = e.toString();
    } finally {
      setState(() => _isCatLoading = false);
    }
  }

  Future<void> _loadEvents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final rawData = await api.getEventsByUser(userId);
    _events = rawData.map((e) => Event.fromJson(e)).toList();

    if (_selectedEventId != null) {
      final event = _events.firstWhere((e) => e.id == _selectedEventId, orElse: () => _events.first);
      _selectedEventName = event.name;
    }
  }

  Future<void> getListWallet() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final data = await api.getWalletsByUser(userId);
    _wallets = data.map((e) => Wallet.fromJson(e, userId)).toList();

    final wallet = _wallets.firstWhere(
      (w) => w.id == widget.transaction.walletId,
      orElse: () => _wallets.first,
    );

    setState(() {
      _selectedWallet = wallet.name ?? '';
      _selectedWalletId = wallet.id ?? '';
    });
  }

  void _showCategoryPickers() {
    if (_categories.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        child: ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return ListTile(
              leading: SuperIcon(iconPath: category.iconId ?? '', size: 24),
              title: Text(category.name ?? ''),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedCategory = category);
              },
            );
          },
        ),
      ),
    );
  }

  void _showWalletPickers() {
    if (_wallets.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        child: ListView.builder(
          itemCount: _wallets.length,
          itemBuilder: (context, index) {
            final wallet = _wallets[index];
            return ListTile(
              leading: SuperIcon(iconPath: wallet.iconId ?? '', size: 24),
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
    );
  }

  void _showEventPickers() {
    if (_events.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        child: ListView.builder(
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return ListTile(
              leading: SuperIcon(iconPath: event.iconPath ?? '', size: 24),
              title: Text(event.name ?? ''),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedEventName = event.name;
                  _selectedEventId = event.id;
                });
              },
            );
          },
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

  Future<void> _saveEditedTransaction() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _selectedCategory == null || _selectedWalletId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng điền đầy đủ thông tin hợp lệ")));
      return;
    }

    final updatedTx = {
      'amount': amount,
      'category_id': _selectedCategory!.id,
      'wallet_id': _selectedWalletId,
      'date': _selectedDate.toIso8601String(),
      'note': _noteController.text,
      'contact': _contactController.text,
      'event_id': _selectedEventId,
    };

    try {
      await api.updateTransaction(widget.transaction.id, updatedTx);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Icon(icon, color: Colors.amber),
    title: Text(label, style: TextStyle(color: Colors.white)),
    subtitle: value != null ? Text(value, style: TextStyle(color: Colors.grey)) : null,
    trailing: Icon(Icons.chevron_right, color: Colors.white),
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.boxBackgroundColor2,
        title: Text("Sửa giao dịch"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
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
          SizedBox(height: 16),
          _buildTile(
            icon: Icons.category,
            label: 'Chọn nhóm',
            value: _selectedCategory?.name,
            onTap: _showCategoryPickers,
          ),
          _buildTile(
            icon: Icons.account_balance_wallet,
            label: 'Chọn ví',
            value: _selectedWallet,
            onTap: _showWalletPickers,
          ),
          _buildTile(
            icon: Icons.calendar_today,
            label: 'Ngày',
            value: DateFormat.yMMMd().format(_selectedDate),
            onTap: _pickDate,
          ),
          _isEditingNote
              ? TextField(
                  controller: _noteController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(hintText: 'Nhập ghi chú', hintStyle: TextStyle(color: Colors.grey)),
                  onSubmitted: (value) {
                    setState(() {
                      _note = value;
                      _isEditingNote = false;
                    });
                  },
                )
              : _buildTile(
                  icon: Icons.notes,
                  label: 'Ghi chú',
                  value: _noteController.text,
                  onTap: () {
                    setState(() => _isEditingNote = true);
                  },
                ),
          TextButton(
            onPressed: () => setState(() => _showMoreOptions = !_showMoreOptions),
            child: Text(_showMoreOptions ? "Ẩn bớt ▲" : "Thêm lựa chọn ▼", style: TextStyle(color: Colors.teal)),
          ),
          if (_showMoreOptions) ...[
            _buildTile(
              icon: Icons.event,
              label: 'Chọn sự kiện',
              value: _selectedEventName,
              onTap: _showEventPickers,
            ),
            TextField(
              controller: _contactController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_page, color: Colors.amber),
                hintText: 'Nhập tên liên hệ',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _saveEditedTransaction,
            icon: Icon(Icons.save),
            label: Text("Lưu thay đổi"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

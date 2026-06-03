import 'package:flutter/material.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/EventModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/GUI/widgets/icon_picker.dart';
import 'package:nhom4/core/model/wallet_model.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String? _name;
  DateTime? _endDate;
  String? _walletId;
  String? _selectedWalletName; // Added for displaying wallet name
  int? _isFinished = 0;
  double? _spent;
  int? _finishedByHand = 0;
  int? _autofinish = 0;
  String? _transactionIdList;
  String _iconId = 'assets/icons/travel_2.svg';
  bool _isLoading = false;
  String? _errorMessage;
  List<Wallet> _wallets = []; // Added for wallet list
  bool _isWalletLoading = false; // Added for wallet loading state
  String _walletError = ''; // Added for wallet error state

  @override
  void initState() {
    super.initState();
    _loadWallets(); // Fetch wallets on initialization
  }

  Future<void> _loadWallets() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _walletError = 'Chưa đăng nhập');
      return;
    }
    setState(() {
      _isWalletLoading = true;
      _walletError = '';
    });
    try {
      final data = await apiService.getWalletsByUser(userId);
      if (data != null) {
        _wallets = data.map((e) => Wallet.fromJson(e, userId)).toList();
      } else {
        _wallets = [];
      }
    } catch (e) {
      _walletError = e.toString();
    } finally {
      setState(() => _isWalletLoading = false);
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
            color: Color(0xFF1E1E1E), // Match dark theme
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn ví',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
                        title: Text(
                          wallet.name ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _walletId = wallet.id;
                            _selectedWalletName = wallet.name;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_endDate == null) {
      setState(() {
        _errorMessage = 'Vui lòng chọn ngày kết thúc';
      });
      return;
    }
    if (_walletId == null || _walletId!.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng chọn ví';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Không tìm thấy người dùng!';
      final uuid = Uuid();
      String newId = uuid.v4();
      final newEvent = Event(
        id: newId,
        userId: user.uid,
        name: _name,
        iconPath: _iconId,
        endDate: _endDate,
        walletId: _walletId,
        isFinished: _isFinished,
        spent: _spent,
        finishedByHand: _finishedByHand,
        autofinish: _autofinish,
        transactionIdList: _transactionIdList ?? '',
      );
      print(newEvent.toJson());
      await apiService.createEvent(newEvent.toJson());
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tạo sự kiện: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFB0BEC5)),
      title: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      subtitle:
          value != null && value.isNotEmpty
              ? Text(
                value,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              )
              : null,
      trailing: Icon(Icons.chevron_right, color: Color(0xFFB0BEC5)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Tạo sự kiện mới',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFB0BEC5)),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFF44336),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (_walletError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _walletError,
                            style: const TextStyle(
                              color: Color(0xFFF44336),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      Card(
                        color: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(
                                label: 'Tên sự kiện',
                                icon: Icons.event,
                                onSaved: (val) => _name = val,
                                validator: true,
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  final selectedIcon = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => IconPicker(),
                                    ),
                                  );
                                  if (selectedIcon != null) {
                                    setState(() {
                                      _iconId = selectedIcon;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2C),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF3C3C3C),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SuperIcon(iconPath: _iconId, size: 32),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Chọn biểu tượng',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _pickDate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C2C2C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.date_range,
                                  color: Color(0xFFB0BEC5),
                                ),
                                label: Text(
                                  _endDate == null
                                      ? 'Chọn ngày kết thúc'
                                      : 'Ngày kết thúc: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildTile(
                                icon: Icons.account_balance_wallet,
                                label: 'Chọn ví',
                                value: _selectedWalletName,
                                onTap: _showWalletPickers,
                              ),
                              _buildTextField(
                                label: 'Đã chi (spent)',
                                icon: Icons.money,
                                onSaved:
                                    (val) =>
                                        _spent = double.tryParse(val ?? ''),
                                keyboardType: TextInputType.number,
                                validatorNumber: true,
                              ),
                              const SizedBox(height: 16),
                              _buildDropdown(
                                label: 'Đã hoàn thành',
                                value: _isFinished,
                                onChanged:
                                    (val) => setState(() => _isFinished = val),
                                onSaved: (val) => _isFinished = val,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ).copyWith(
                          backgroundBuilder: (context, states, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF388E3C),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: child,
                            );
                          },
                        ),
                        icon: const Icon(Icons.check, size: 24),
                        label: const Text(
                          'Tạo sự kiện',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    void Function(String?)? onSaved,
    TextInputType keyboardType = TextInputType.text,
    bool validator = false,
    bool validatorNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFFB0BEC5)),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF44336), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF44336), width: 2),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (validator && (value == null || value.isEmpty))
            return 'Không được để trống';
          if (validatorNumber &&
              value != null &&
              value.isNotEmpty &&
              double.tryParse(value) == null) {
            return 'Vui lòng nhập số hợp lệ';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required void Function(int?) onChanged,
    required void Function(int?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        dropdownColor: const Color(0xFF1E1E1E),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
        ),
        value: value,
        items: const [
          DropdownMenuItem(
            value: 0,
            child: Text('Không', style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text('Có', style: TextStyle(color: Colors.white)),
          ),
        ],
        onChanged: onChanged,
        onSaved: onSaved,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        iconEnabledColor: const Color(0xFFB0BEC5),
      ),
    );
  }
}

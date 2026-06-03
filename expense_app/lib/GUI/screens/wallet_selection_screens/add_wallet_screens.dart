import 'package:flutter/material.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:nhom4/GUI/widgets/icon_picker.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/wallet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/GUI/screens/home_screen/home_screen.dart';

final api = ApiService();

class CreateWalletScreen extends StatefulWidget {
  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _walletNameController = TextEditingController();
  final List<String> _currencies = ['VNĐ', '\$', '€', '¥', '£'];

  String _currency = 'VNĐ';
  String _balance = '0';
  String _selectedIconPath = 'assets/icons/wallet.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tạo ví', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              createWallet();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Tên ví
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => IconPicker()),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedIconPath = selected;
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      child: SuperIcon(
                        iconPath: _selectedIconPath,
                        size: 32.0, // hoặc bất kỳ size nào bạn muốn
                      ),
                    ),
                  ),

                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _walletNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tên ví',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Loại tiền
            _buildItemTile(
              Icons.attach_money,
              _currency,
              onTap: _showCurrencyPicker,
            ),

            // Số dư ban đầu
            _buildItemTile(
              Icons.account_balance_wallet,
              _balance,
              onTap: _showBalanceInputDialog,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[300], // màu vàng nhạt
            foregroundColor: Colors.black, // chữ đen
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            createWallet();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Text(
            'Tạo ví',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(
    IconData icon,
    String text, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(color: Colors.white))),
            Icon(Icons.chevron_right, color: Colors.white30),
          ],
        ),
      ),
    );
  }

  // Hàm để hiển thị hộp thoại chọn loại tiền
  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: _currencies.length,
          separatorBuilder: (_, __) => Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final currency = _currencies[index];
            return ListTile(
              title: Text(
                currency,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                setState(() {
                  _currency = currency;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  // Hàm để hiển thị hộp thoại nhập số dư ban đầu
  void _showBalanceInputDialog() {
    final TextEditingController _balanceController = TextEditingController(
      text: _balance,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Nhập số dư ban đầu',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: _balanceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white38),
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _balance = _balanceController.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: Text('Lưu', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void createWallet() async {
    final uuid = Uuid();
    String newId = uuid.v4();
    String walletName = _walletNameController.text.trim();
    String walletIcon = _selectedIconPath;
    String walletCurrency = _currency;
    double walletBalance = double.tryParse(_balance) ?? 0.0;
    String userId = user?.uid ?? '';
    List wallets = await api.getWalletsByUser(userId);

    if (walletName.isEmpty) {
      // Hiển thị thông báo lỗi nếu tên ví trống
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng nhập tên ví')));
      return;
    }

    Wallet NewWallet = Wallet(
      id: newId,
      name: walletName,
      iconId: walletIcon,
      currencyId: walletCurrency,
      amount: walletBalance,
      userId: userId,
    );
    if (walletBalance <= 0) {
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

    final walletData = NewWallet.toJson();
    final userData = {"current_wallet_id": newId};

    if (wallets.length == 0) {
      //tạo ví đầu tiên thành ví mặc định
      await api.updateUser(userId, userData);
    }
    await api.createWallet(walletData);
    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tạo ví thành công')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}

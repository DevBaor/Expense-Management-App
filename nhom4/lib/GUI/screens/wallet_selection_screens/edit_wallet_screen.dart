import 'package:flutter/material.dart';
import 'package:nhom4/core/model/wallet_model.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/GUI/widgets/icon_picker.dart';
import 'package:intl/intl.dart';
final api = ApiService();
class EditWalletScreen extends StatefulWidget {
  final Wallet wallet;

  const EditWalletScreen({required this.wallet});

  @override
  _EditWalletScreenState createState() => _EditWalletScreenState();
}

class _EditWalletScreenState extends State<EditWalletScreen> {
  final TextEditingController _walletNameController = TextEditingController();
  String _currency = 'VNĐ';
  String _selectedIconPath = 'assets/icons/wallet.svg';
  final List<String> _currencies = ['VNĐ', '\$', '€', '¥', '£'];

  @override
  void initState() {
    super.initState();
    final w = widget.wallet;
    _walletNameController.text = w.name ?? '';
    _currency = w.currencyId ?? 'VNĐ';
    _selectedIconPath = w.iconId ?? 'assets/icons/wallet.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chỉnh sửa ví', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _updateWallet,
            child: Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNameField(),
            SizedBox(height: 16),
            _buildItemTile(Icons.attach_money, _currency, onTap: _showCurrencyPicker),
            SizedBox(height: 16),
            _buildBalanceDisplay(widget.wallet.amount ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
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
            child: SuperIcon(iconPath: _selectedIconPath, size: 32),
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
    );
  }

  Widget _buildItemTile(IconData icon, String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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

  Widget _buildBalanceDisplay(double amount) {
    final formatted = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: Colors.white70),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              formatted,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text('(không đổi được)', style: TextStyle(color: Colors.white54))
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: _currencies.length,
          separatorBuilder: (_, __) => Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final currency = _currencies[index];
            return ListTile(
              title: Text(currency, style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _currency = currency);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _updateWallet() async {
    final name = _walletNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập tên ví')));
      return;
    }

    final updated = widget.wallet.copyWith(
      name: name,
      iconId: _selectedIconPath,
      currencyId: _currency,
    );
    await api.updateWallet(updated.id ?? '', updated.toJson());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thành công')));
    Navigator.pop(context, true);
  }
}

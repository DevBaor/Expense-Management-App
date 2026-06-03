import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'add_wallet_screens.dart';
import 'package:nhom4/core/model/wallet_model.dart';
import 'package:nhom4/core/model/usersModel.dart';
import 'edit_wallet_screen.dart';

final api = ApiService();

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  List<Wallet> _wallets = [];
  String? _catError;

  @override
  void initState() {
    super.initState();
    _fetchWallets();
  }

  Future<void> _fetchWallets() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _catError = 'Chưa đăng nhập');
      return;
    }
    final data = await api.getWalletsByUser(userId);
    if (data != null) {
      setState(() {
        _wallets = data.map((e) => Wallet.fromJson(e, userId)).toList();
      });
    }
  }

  Future<Users?> _fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid.isEmpty) {
      return null;
    }
    final userJson = await ApiService().getUser(user.uid);
    if (userJson != null && userJson is Map<String, dynamic>) {
      return Users.fromJson(userJson);
    }
    return null;
  }

  void _showWalletOptions(BuildContext context, Wallet wallet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tùy chọn ví', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Sửa', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditWalletScreen(wallet: wallet),
                    ),
                  );
                  if (result == true) {
                    _fetchWallets();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Xóa', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Xác nhận xóa'),
                      content: const Text('Bạn có chắc muốn xóa ví này không?'),
                      actions: [
                        TextButton(
                          child: const Text('Hủy'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: const Text('Xóa'),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await api.deleteWallet(wallet.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã xóa ví')),
                      );
                      _fetchWallets();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
              Color(0xFF1C2526),
              Color(0xFF2D3338),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ví của tôi",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateWalletScreen(),
                          ),
                        ).then((value) => _fetchWallets());
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _catError != null
                    ? Center(
                        child: Text(
                          _catError!,
                          style: const TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      )
                    : FutureBuilder<Users?>(
                        future: _fetchUser(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          }

                          final currentWalletId = userSnapshot.data?.currentWalletId;
                          List<Wallet> sortedWallets = List.from(_wallets);
                          if (currentWalletId != null) {
                            sortedWallets.sort((a, b) {
                              bool aIsCurrent = a.id == currentWalletId;
                              bool bIsCurrent = b.id == currentWalletId;
                              if (aIsCurrent && !bIsCurrent) return -1;
                              if (!aIsCurrent && bIsCurrent) return 1;
                              return 0;
                            });
                          }

                          if (sortedWallets.isEmpty) {
                            return const Center(
                              child: Text(
                                "Không có ví nào.",
                                style: TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: sortedWallets.length,
                            itemBuilder: (context, index) {
                              final wallet = sortedWallets[index];
                              final isCurrentWallet = currentWalletId == wallet.id;
                              return _buildWalletItem(context, wallet, isCurrentWallet);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletItem(BuildContext context, Wallet wallet, bool isCurrentWallet) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: const Color(0xFF2D3338),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: SuperIcon(
          iconPath: wallet.iconId,
          size: 24,
        ),
        title: Text(
          wallet.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatter.format(wallet.amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: wallet.amount >= 0 ? const Color(0xFF00D68F) : const Color(0xFFFF2D55),
              ),
            ),
            if (isCurrentWallet)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.star, color: Color(0xFFFFFFA500), size: 20),
              ),
          ],
        ),
        onTap: () => _showWalletOptions(context, wallet),
      ),
    );
  }
}

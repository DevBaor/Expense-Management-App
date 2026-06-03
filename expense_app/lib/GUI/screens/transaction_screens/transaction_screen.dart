import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/TransactionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nhom4/GUI/screens/transaction_screens/edit_transaction_screen.dart';

final api = ApiService();

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  static Future<void> initializeDateFormattingForApp() async {
    await initializeDateFormatting('vi', null);
  }

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late Future<List<dynamic>?> transactionsFuture;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    TransactionScreen.initializeDateFormattingForApp();
  }

  void _loadTransactions() {
    transactionsFuture = api.getTransactionsByUser(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'Lịch sử giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Colors.white70)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Không có giao dịch', style: TextStyle(color: Colors.white70, fontSize: 16)),
            );
          } else {
            final transactions = snapshot.data!
                .map((json) => Transaction.fromJson(json, userId: userId!))
                .toList();
            final groupedTransactions = _groupTransactionsByDate(transactions);

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final date = groupedTransactions.keys.elementAt(index);
                final dailyTransactions = groupedTransactions[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(
                        _formatDateHeader(date),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    ...dailyTransactions.map((tx) => _buildTransactionCard(context, tx)).toList(),
                    SizedBox(height: 16),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};
    for (var tx in transactions) {
      if (tx.date != null) {
        final date = DateTime(tx.date!.year, tx.date!.month, tx.date!.day);
        grouped.putIfAbsent(date, () => []).add(tx);
      }
    }
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    if (date == today) return 'Hôm nay';
    if (date == yesterday) return 'Hôm qua';
    return DateFormat('dd MMMM yyyy', 'vi').format(date);
  }

  Widget _buildTransactionCard(BuildContext context, Transaction tx) {
    return Card(
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        onTap: () => _showTransactionOptions(context, tx),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: FutureBuilder<String>(
          future: getCategoryIcon(tx.categoryId ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            } else if (snapshot.hasError) {
              return Icon(Icons.error, color: Colors.red);
            } else {
              return SuperIcon(iconPath: snapshot.data!, size: 32);
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                tx.note ?? 'Không có ghi chú',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            FutureBuilder<String>(
              future: getCategoryType(tx.categoryId ?? ''),
              builder: (context, snapshot) {
                Color amountColor;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  amountColor = Colors.white70;
                } else if (snapshot.hasError || !snapshot.hasData) {
                  amountColor = Colors.red;
                } else {
                  amountColor = snapshot.data == 'income' ? Colors.green : Colors.red;
                }
                return Text(
                  '${tx.amount?.toStringAsFixed(0) ?? '0'} VND',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: amountColor),
                );
              },
            ),
          ],
        ),
        subtitle: Text(
          tx.date != null ? DateFormat('HH:mm', 'vi').format(tx.date!) : 'Không rõ giờ',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

  Future<String> getCategoryIcon(String categoryId) async {
    try {
      final category = await api.getCategory(categoryId);
      if (category != null && category['icon_id'] != null) {
        return category['icon_id'] as String;
      }
    } catch (e) {
      print('Lỗi khi lấy icon danh mục: $e');
    }
    return 'assets/icons/debt.svg';
  }

  Future<String> getCategoryType(String categoryId) async {
    try {
      final category = await api.getCategory(categoryId);
      if (category != null && category['type'] != null) {
        return category['type'] as String;
      }
    } catch (e) {
      print('Lỗi khi lấy loại danh mục: $e');
    }
    return 'expense';
  }

  void _showTransactionOptions(BuildContext context, Transaction tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tùy chọn giao dịch', style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditTransactionScreen(transaction: tx),
                    ),
                  );
                  if (result == true) {
                    setState(() {
                      _loadTransactions();
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Xác nhận xóa'),
                      content: Text('Bạn có chắc muốn xóa giao dịch này?'),
                      actions: [
                        TextButton(child: Text('Hủy'), onPressed: () => Navigator.of(context).pop(false)),
                        TextButton(child: Text('Xóa'), onPressed: () => Navigator.of(context).pop(true)),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await api.deleteTransaction(tx.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa giao dịch")));
                      setState(() {
                        _loadTransactions();
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
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
}

import 'package:flutter/material.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/GUI/screens/transaction_screens/transaction_screen.dart';
import 'package:nhom4/GUI/screens/transaction_screens/add_transaction_screens.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/GUI/screens/introduction_screens/first_wallet_screen.dart';
import 'package:nhom4/GUI/screens/report_screens/report_screen.dart';
import 'package:nhom4/GUI/screens/account_screens/account_screen.dart';
import 'package:nhom4/GUI/screens/budget_screens/budget_screen.dart';
final api = ApiService();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkUserWallet();
  }

  void _checkUserWallet() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      try {
        List wallets = await api.getWalletsByUser(userId);
        if (wallets.isEmpty) {
          // Nếu chưa có ví thì chuyển sang FirstWalletScreen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FirstWalletScreen()),
            );
          });
        }
      } catch (e) {
        print('Lỗi khi lấy danh sách ví: $e');
      }
    }
  }

  void _onItemTap(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      TransactionScreen(),
      ReportScreen(),
      Center(child: Text('Add Transaction Screen Layout')),
     BudgetScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: Style.boxBackgroundColor2,
      body: _screens.elementAt(selectedIndex),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: Style.backgroundColor,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 25.0),
              label: 'Giao dịch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_sharp, size: 25.0),
              label: 'Báo cáo',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: Colors.transparent,
                size: 0.0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_sharp, size: 25.0),
              label: 'Ngân sách',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 25.0),
              label: 'Tài khoản',
            ),
          ],
          selectedLabelStyle: TextStyle(
            fontFamily: Style.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: Style.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          selectedItemColor: Style.foregroundColor,
          unselectedItemColor: Style.foregroundColor.withOpacity(0.54),
          unselectedFontSize: 12.0,
          selectedFontSize: 12.0,
          currentIndex: selectedIndex,
          onTap: _onItemTap,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        backgroundColor: Style.primaryColor,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

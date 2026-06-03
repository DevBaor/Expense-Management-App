import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/usersModel.dart';
import 'package:nhom4/GUI/screens/authentication_screens/logintest.dart';
import 'package:page_transition/page_transition.dart';
import 'package:nhom4/GUI/screens/wallet_selection_screens/wallet_screen.dart';
import 'package:nhom4/GUI/screens/categories_screens/category_screen.dart';
import 'package:nhom4/GUI/screens/planning_screens/event_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
              Color(0xFF1C2526), // Dark background
              Color(0xFF2D3338), // Slightly lighter shade
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Users?>(
            future: _fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    "Không tìm thấy người dùng.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                );
              }

              final user = snapshot.data!;
              return Column(
                children: [
                  // Header with user info
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3338),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(
                            0xFFFFA500,
                          ), // Yellow-orange accent
                          child: Text(
                            user.username?.isNotEmpty == true
                                ? user.username![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username?.isNotEmpty == true
                                    ? user.username!
                                    : 'Không có tên',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildMenuItem(
                          icon: Icons.account_balance_wallet,
                          title: "Ví của tôi",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletListScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.group,
                          title: "Nhóm",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoriesScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.event,
                          title: "Sự kiện",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.receipt_long,
                          title: "Hóa đơn",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.repeat,
                          title: "Giao dịch định kỳ",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: "Hỗ trợ",
                          onTap: () {
                            ApiService.openHotroPage();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.info_outline,
                          title: "Giới thiệu",
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                        // Logout button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: LoginScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text("Đăng xuất"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFFF2D55,
                              ), // Red accent
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: const Color(0xFF2D3338),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            color: const Color(0xFFFFA500),
          ), // Yellow-orange accent
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

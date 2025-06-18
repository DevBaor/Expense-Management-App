import 'package:flutter/material.dart';
import 'package:nhom4/GUI/screens/wallet_selection_screens/add_wallet_screens.dart';

class FirstWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Nền xám
      body: Center(
        child: Container(
          width: 280,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hướng dẫn tạo ví',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Bạn chưa có ví, hãy tạo ví để bắt đầu quản lý tài chính của bạn!',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // 👉 Thêm màn hình tạo ví tại đây
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateWalletScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[300], // Màu vàng nhạt
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text('Tạo ví ngay'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Quay lại nếu bỏ qua
                },
                child: Text('Bỏ qua'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

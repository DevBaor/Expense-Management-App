import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/GUI/style.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:nhom4/core/model/CategoryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhom4/core/model/super_icon_model.dart';
import 'package:uuid/uuid.dart';
import 'package:nhom4/GUI/widgets/icon_picker.dart';

final api = ApiService();

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _type; // sẽ lưu 'income' hoặc 'expense'
  String _name = '';
  final _userId = FirebaseAuth.instance.currentUser?.uid;
  String _iconId = 'assets/icons/shopping.svg';

  // Map dùng để chuyển giữa tên hiển thị và giá trị thực
  final Map<String, String> typeMap = {
    'Thu nhập': 'income',
    'Chi tiêu': 'expense',
  };

  @override
  Widget build(BuildContext context) {
    // Lấy tên hiển thị dựa trên _type đã lưu
    String typeDisplay = 'Chọn loại';
    if (_type != null) {
      typeDisplay =
          typeMap.entries
              .firstWhere(
                (entry) => entry.value == _type,
                orElse: () => MapEntry('Chọn loại', ''),
              )
              .key;
    }

    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A), // Nền tối giống màn hình danh sách
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        title: Text('Thêm Nhóm', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon hiển thị và bấm để mở IconPicker
            GestureDetector(
              onTap: () async {
                final selectedIcon = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IconPicker()),
                );
                if (selectedIcon != null) {
                  setState(() {
                    _iconId = selectedIcon;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SuperIcon(iconPath: _iconId, size: 32),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Dropdown cho type với tên hiển thị tiếng Việt
            ListTile(
              tileColor: Color(0xFF2A2A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(typeDisplay, style: TextStyle(color: Colors.white)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            typeMap.keys.map((String displayValue) {
                              return ListTile(
                                title: Text(
                                  displayValue,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() => _type = typeMap[displayValue]);
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                      ),
                );
              },
            ),

            SizedBox(height: 10),

            // TextField cho name
            ListTile(
              tileColor: Color(0xFF2A2A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Tên category',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) => _name = value,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ),

            SizedBox(height: 20),

            // Nút submit
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50), // Màu xanh lá nhạt
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_type != null && _name.isNotEmpty) {
                    final uuid = Uuid();
                    String newId = uuid.v4();

                    final category = {
                      'id': newId, // bạn có thể thêm id uuid nếu cần
                      'user_id': _userId,
                      'name': _name,
                      'type': _type, // 'income' hoặc 'expense'
                      'icon_id': _iconId,
                    };
                    print('Category added: $category');
                    api.createCategory(category);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Thêm thành công!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                    );

                    // TODO: Thực hiện gọi API lưu category ở đây

                    Navigator.pop(context); // Quay lại màn trước sau khi thêm
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Vui lòng nhập đủ thông tin',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Thêm', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1A1A1A),
      ),
      home: AddCategoryScreen(),
    ),
  );
}

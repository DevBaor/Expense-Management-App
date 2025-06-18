import 'package:nhom4/core/API/API_Helper.dart';

final api = ApiService();

class Category {
  final String id;
  final String userId;
  final String? name;
  final String? type;
  final String? iconId;

  Category({
    required this.id,
    required this.userId,
    this.name,
    this.type,
    this.iconId,
  });

  factory Category.fromJson(
    Map<String, dynamic> json, {
    required String userId,
  }) {
    return Category(
      id: json['id'] as String,
      userId: userId, // dùng giá trị truyền vào
      name: json['name'] as String?,
      type: json['type'] as String?,
      iconId: json['icon_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'icon_id': iconId,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, userId: $userId, name: $name, type: $type, iconId: $iconId)';
  }
}

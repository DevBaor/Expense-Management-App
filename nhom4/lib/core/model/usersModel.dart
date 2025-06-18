class Users {
  final String id;
  final String? username;
  final String? currentWalletId;

  Users({required this.id, this.username, this.currentWalletId});

  // Tạo User từ Map (ví dụ JSON)
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as String,
      username: json['username'] as String?,
      currentWalletId: json['current_wallet_id'] as String?,
    );
  }

  // Chuyển User thành Map để gửi lên API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'current_wallet_id': currentWalletId,
    };
  }
}

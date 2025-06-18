class Wallet {
  final String id;
  final String userId;
  final String name;
  final double amount;
  final String currencyId;
  final String iconId;

  Wallet({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.currencyId,
    required this.iconId,
  });

  factory Wallet.fromJson(Map<String, dynamic> json, String userId) {
    return Wallet(
      id: json['id'] as String,
      userId: userId, // ✅ Dùng userId truyền vào
      name: json['name'] as String,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currencyId: json['currency_id'] as String,
      iconId: json['icon_id'] as String,
    );
  }

  // Chuyển Wallet thành JSON để gửi lên API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount': amount,
      'currency_id': currencyId,
      'icon_id': iconId,
    };
  }

  Wallet copyWith({
    String? name,
    double? amount,
    String? currencyId,
    String? iconId,
  }) {
    return Wallet(
      id: this.id,
      userId: this.userId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      iconId: iconId ?? this.iconId,
    );
  }
}

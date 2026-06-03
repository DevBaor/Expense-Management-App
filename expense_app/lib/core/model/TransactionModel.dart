class Transaction {
  final String id;
  final String userId;
  final double? amount;
  final double? extraAmountInfo;
  final DateTime? date;
  final String? note;
  final String? currencyId;
  final String? categoryId;
  final String? budgetId;
  final String? eventId;
  final String? billId;
  final String? contact;
  final String? walletId;

  Transaction({
    required this.id,
    required this.userId,
    this.amount,
    this.extraAmountInfo,
    this.date,
    this.note,
    this.currencyId,
    this.categoryId,
    this.budgetId,
    this.eventId,
    this.billId,
    this.contact,
    this.walletId,
  });

  // Tạo Transaction từ JSON
  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    required String userId,
  }) {
    return Transaction(
      id: json['id'] as String,
      userId: userId,
      amount:
          json['amount'] != null
              ? double.tryParse(json['amount'].toString())
              : null,
      extraAmountInfo:
          json['extra_amount_info'] != null
              ? double.tryParse(json['extra_amount_info'].toString())
              : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      note: json['note'] as String?,
      currencyId: json['currency_id'] as String?,
      categoryId: json['category_id'] as String?,
      budgetId: json['budget_id'] as String?,
      eventId: json['event_id'] as String?,
      billId: json['bill_id'] as String?,
      contact: json['contact'] as String?,
      walletId: json['wallet_id'] as String?,
    );
  }

  // Chuyển Transaction thành JSON để gửi lên API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'extra_amount_info': extraAmountInfo,
      'date': date?.toIso8601String(),
      'note': note,
      'currency_id': currencyId,
      'category_id': categoryId,
      'budget_id': budgetId,
      'event_id': eventId,
      'bill_id': billId,
      'contact': contact,
      'wallet_id': walletId,
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, categoryId: $categoryId, date: $date, note: $note)';
  }

  Transaction copyWith({
  double? amount,
  double? extraAmountInfo,
  DateTime? date,
  String? note,
  String? currencyId,
  String? categoryId,
  String? budgetId,
  String? eventId,
  String? billId,
  String? contact,
  String? walletId,
}) {
  return Transaction(
    id: this.id,
    userId: this.userId,
    amount: amount ?? this.amount,
    extraAmountInfo: extraAmountInfo ?? this.extraAmountInfo,
    date: date ?? this.date,
    note: note ?? this.note,
    currencyId: currencyId ?? this.currencyId,
    categoryId: categoryId ?? this.categoryId,
    budgetId: budgetId ?? this.budgetId,
    eventId: eventId ?? this.eventId,
    billId: billId ?? this.billId,
    contact: contact ?? this.contact,
    walletId: walletId ?? this.walletId,
  );
}

}



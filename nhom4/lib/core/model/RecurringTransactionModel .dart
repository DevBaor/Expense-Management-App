class RecurringTransaction {
  final String id;
  final String userId;
  final String? categoryId;
  final double? amount;
  final String? walletId;
  final String? note;
  final String? transactionIdList;
  final String? repeatOptionId;
  final int? isFinished;

  RecurringTransaction({
    required this.id,
    required this.userId,
    this.categoryId,
    this.amount,
    this.walletId,
    this.note,
    this.transactionIdList,
    this.repeatOptionId,
    this.isFinished,
  });

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) {
    return RecurringTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      amount:
          json['amount'] != null
              ? (json['amount'] is String
                  ? double.tryParse(json['amount'])
                  : (json['amount'] as num).toDouble())
              : null,
      walletId: json['wallet_id'] as String?,
      note: json['note'] as String?,
      transactionIdList: json['transaction_id_list'] as String?,
      repeatOptionId: json['repeat_option_id'] as String?,
      isFinished: json['is_finished'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'wallet_id': walletId,
      'note': note,
      'transaction_id_list': transactionIdList,
      'repeat_option_id': repeatOptionId,
      'is_finished': isFinished,
    };
  }
}

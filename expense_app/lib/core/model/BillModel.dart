class Bill {
  final String id;
  final String userId;
  final String? categoryId;
  final double? amount;
  final String? note;
  final String? walletId;
  final String? repeatOptionId;
  final int? isFinished;
  final String? dueDates; // Có thể là JSON hoặc chuỗi nhiều ngày
  final String? paidDueDates;
  final String? transactionIds;

  Bill({
    required this.id,
    required this.userId,
    this.categoryId,
    this.amount,
    this.note,
    this.walletId,
    this.repeatOptionId,
    this.isFinished,
    this.dueDates,
    this.paidDueDates,
    this.transactionIds,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      amount:
          (json['amount'] != null)
              ? double.tryParse(json['amount'].toString())
              : null,
      note: json['note'] as String?,
      walletId: json['wallet_id'] as String?,
      repeatOptionId: json['repeat_option_id'] as String?,
      isFinished: json['is_finished'] as int?,
      dueDates: json['due_dates'] as String?,
      paidDueDates: json['paid_due_dates'] as String?,
      transactionIds: json['transaction_ids'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'note': note,
      'wallet_id': walletId,
      'repeat_option_id': repeatOptionId,
      'is_finished': isFinished,
      'due_dates': dueDates,
      'paid_due_dates': paidDueDates,
      'transaction_ids': transactionIds,
    };
  }
}

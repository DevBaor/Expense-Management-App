class Budget {
  final String id;
  final String? userId;
  final String? categoryId;
  final double? amount;
  final double? spent;
  final String? walletId;
  final int? isFinished;
  final DateTime? beginDate;
  final DateTime? endDate;
  final int? isRepeat;
  final String? label;

  Budget({
    required this.id,
    required this.userId,
    this.categoryId,
    this.amount,
    this.spent,
    this.walletId,
    this.isFinished,
    this.beginDate,
    this.endDate,
    this.isRepeat,
    this.label,
  });

  factory Budget.fromJson(Map<String, dynamic> json, String userid) {
    return Budget(
      id: json['id'] as String,
     userId: userid,
      categoryId: json['category_id'] as String?,
      amount:
          (json['amount'] != null)
              ? double.tryParse(json['amount'].toString())
              : null,
      spent:
          (json['spent'] != null)
              ? double.tryParse(json['spent'].toString())
              : null,
     walletId: json['wallet_id']?.toString(),
      isFinished: json['is_finished'] as int?,
      beginDate:
          json['begin_date'] != null
              ? DateTime.parse(json['begin_date'])
              : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isRepeat: json['is_repeat'] as int?,
      label: json['label']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'spent': spent,
      'wallet_id': walletId,
      'is_finished': isFinished,
      'begin_date': beginDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_repeat': isRepeat,
      'label': label,
    };
  }
}

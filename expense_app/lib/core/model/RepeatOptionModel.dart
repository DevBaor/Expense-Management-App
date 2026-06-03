class RepeatOption {
  final String id;
  final String userId;
  final String? frequency;
  final int? rangeAmount;
  final String? extraAmountInfo;
  final DateTime? beginDatetime;
  final String? type;
  final String? extraTypeInfo;

  RepeatOption({
    required this.id,
    required this.userId,
    this.frequency,
    this.rangeAmount,
    this.extraAmountInfo,
    this.beginDatetime,
    this.type,
    this.extraTypeInfo,
  });

  // Tạo từ JSON
  factory RepeatOption.fromJson(Map<String, dynamic> json) {
    return RepeatOption(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      frequency: json['frequency'] as String?,
      rangeAmount: json['range_amount'] as int?,
      extraAmountInfo: json['extra_amount_info'] as String?,
      beginDatetime:
          json['begin_datetime'] != null
              ? DateTime.parse(json['begin_datetime'])
              : null,
      type: json['type'] as String?,
      extraTypeInfo: json['extra_type_info'] as String?,
    );
  }

  // Chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'frequency': frequency,
      'range_amount': rangeAmount,
      'extra_amount_info': extraAmountInfo,
      'begin_datetime': beginDatetime?.toIso8601String(),
      'type': type,
      'extra_type_info': extraTypeInfo,
    };
  }
}

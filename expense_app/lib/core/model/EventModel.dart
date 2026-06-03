class Event {
  final String id;
  final String userId;
  final String? name;
  final String? iconPath;
  final DateTime? endDate;
  final String? walletId;
  final int? isFinished;
  final double? spent;
  final int? finishedByHand;
  final int? autofinish;
  final String? transactionIdList;

  Event({
    required this.id,
    required this.userId,
    this.name,
    this.iconPath,
    this.endDate,
    this.walletId,
    this.isFinished,
    this.spent,
    this.finishedByHand,
    this.autofinish,
    this.transactionIdList,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString(),
      iconPath: json['icon_path']?.toString(),
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      walletId: json['wallet_id']?.toString(),
      isFinished:
          json['is_finished'] is int
              ? json['is_finished']
              : int.tryParse(json['is_finished'].toString()),
      spent:
          json['spent'] != null
              ? (json['spent'] is String
                  ? double.tryParse(json['spent'])
                  : (json['spent'] as num).toDouble())
              : null,
      finishedByHand:
          json['finished_by_hand'] is int
              ? json['finished_by_hand']
              : int.tryParse(json['finished_by_hand'].toString()),
      autofinish:
          json['autofinish'] is int
              ? json['autofinish']
              : int.tryParse(json['autofinish'].toString()),
      transactionIdList: json['transaction_id_list']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon_path': iconPath,
      'end_date': endDate?.toIso8601String(),
      'wallet_id': walletId,
      'is_finished': isFinished,
      'spent': spent,
      'finished_by_hand': finishedByHand,
      'autofinish': autofinish,
      'transaction_id_list': transactionIdList,
    };
  }
}

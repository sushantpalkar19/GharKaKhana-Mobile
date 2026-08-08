class SubscriptionOrder {
  final String id;
  final String messId;
  final String messName;
  final String planName;
  final String startDate;
  final String expiryDate;
  final String status;
  final int amountPaid;
  final String mealTime;

  SubscriptionOrder({
    required this.id,
    required this.messId,
    required this.messName,
    required this.planName,
    required this.startDate,
    required this.expiryDate,
    required this.status,
    required this.amountPaid,
    required this.mealTime,
  });

  factory SubscriptionOrder.fromJson(Map<String, dynamic> json) {
    return SubscriptionOrder(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      messId: json['messId'] as String? ?? '',
      messName: json['messName'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      amountPaid: (json['amountPaid'] as num?)?.toInt() ?? 0,
      mealTime: json['mealTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messId': messId,
      'messName': messName,
      'planName': planName,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'status': status,
      'amountPaid': amountPaid,
      'mealTime': mealTime,
    };
  }

  SubscriptionOrder copyWith({
    String? id,
    String? messId,
    String? messName,
    String? planName,
    String? startDate,
    String? expiryDate,
    String? status,
    int? amountPaid,
    String? mealTime,
  }) {
    return SubscriptionOrder(
      id: id ?? this.id,
      messId: messId ?? this.messId,
      messName: messName ?? this.messName,
      planName: planName ?? this.planName,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      amountPaid: amountPaid ?? this.amountPaid,
      mealTime: mealTime ?? this.mealTime,
    );
  }
}

class Review {
  final String? id;
  final String? userId;
  final String? messId;
  final int rating;
  final String? title;
  final String comment;
  final List<String> images;
  final bool isEdited;
  final DateTime? createdAt;

  Review({
    this.id,
    this.userId,
    this.messId,
    required this.rating,
    this.title,
    required this.comment,
    List<String>? images,
    this.isEdited = false,
    this.createdAt,
  }) : images = images ?? const [];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] as String? ?? json['id'] as String?,
      userId: json['userId'] as String?,
      messId: json['messId'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      comment: json['comment'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isEdited: json['isEdited'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId,
      if (messId != null) 'messId': messId,
      'rating': rating,
      if (title != null) 'title': title,
      'comment': comment,
      'images': images,
      'isEdited': isEdited,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  Review copyWith({
    String? id,
    String? userId,
    String? messId,
    int? rating,
    String? title,
    String? comment,
    List<String>? images,
    bool? isEdited,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messId: messId ?? this.messId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

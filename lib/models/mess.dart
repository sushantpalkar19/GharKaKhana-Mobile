class TodayMenu {
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> dinner;

  TodayMenu({
    List<String>? breakfast,
    List<String>? lunch,
    List<String>? dinner,
  })  : breakfast = breakfast ?? const [],
        lunch = lunch ?? const [],
        dinner = dinner ?? const [];

  factory TodayMenu.fromJson(Map<String, dynamic> json) {
    return TodayMenu(
      breakfast: (json['breakfast'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      lunch: (json['lunch'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      dinner: (json['dinner'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    };
  }

  TodayMenu copyWith({
    List<String>? breakfast,
    List<String>? lunch,
    List<String>? dinner,
  }) {
    return TodayMenu(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }
}

class MessPlan {
  final String id;
  final String name;
  final String duration;
  final int price;
  final int originalPrice;
  final int deliveriesPerDay;
  final bool includesSundaySpecial;
  final List<String> features;
  final bool popular;

  MessPlan({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.deliveriesPerDay,
    required this.includesSundaySpecial,
    List<String>? features,
    this.popular = false,
  }) : features = features ?? const [];

  factory MessPlan.fromJson(Map<String, dynamic> json) {
    return MessPlan(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      originalPrice: (json['originalPrice'] as num?)?.toInt() ?? 0,
      deliveriesPerDay: (json['deliveriesPerDay'] as num?)?.toInt() ?? 1,
      includesSundaySpecial: json['includesSundaySpecial'] as bool? ?? false,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      popular: json['popular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'originalPrice': originalPrice,
      'deliveriesPerDay': deliveriesPerDay,
      'includesSundaySpecial': includesSundaySpecial,
      'features': features,
      'popular': popular,
    };
  }

  MessPlan copyWith({
    String? id,
    String? name,
    String? duration,
    int? price,
    int? originalPrice,
    int? deliveriesPerDay,
    bool? includesSundaySpecial,
    List<String>? features,
    bool? popular,
  }) {
    return MessPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      deliveriesPerDay: deliveriesPerDay ?? this.deliveriesPerDay,
      includesSundaySpecial: includesSundaySpecial ?? this.includesSundaySpecial,
      features: features ?? this.features,
      popular: popular ?? this.popular,
    );
  }
}

class MessReview {
  final String id;
  final String userName;
  final String userRole;
  final String avatar;
  final int rating;
  final String comment;
  final String date;

  MessReview({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory MessReview.fromJson(Map<String, dynamic> json) {
    return MessReview(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userRole: json['userRole'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userRole': userRole,
      'avatar': avatar,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }

  MessReview copyWith({
    String? id,
    String? userName,
    String? userRole,
    String? avatar,
    int? rating,
    String? comment,
    String? date,
  }) {
    return MessReview(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      avatar: avatar ?? this.avatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}

class Mess {
  final String? id;
  final String name;
  final String tagline;
  final List<String> cuisineType;
  final String address;
  final String distance;
  final double rating;
  final int totalReviews;
  final int hygieneScore;
  final int priceStartingAt;
  final bool isVerified;
  final String image;
  final String bannerImage;
  final String ownerName;
  final String phone;
  final String timings;
  final TodayMenu todayMenu;
  final List<MessPlan> plans;
  final List<MessReview> reviews;
  final List<String> tags;

  Mess({
    this.id,
    required this.name,
    required this.tagline,
    List<String>? cuisineType,
    required this.address,
    required this.distance,
    required this.rating,
    required this.totalReviews,
    required this.hygieneScore,
    required this.priceStartingAt,
    required this.isVerified,
    required this.image,
    required this.bannerImage,
    required this.ownerName,
    required this.phone,
    required this.timings,
    TodayMenu? todayMenu,
    List<MessPlan>? plans,
    List<MessReview>? reviews,
    List<String>? tags,
  })  : cuisineType = cuisineType ?? const [],
        todayMenu = todayMenu ?? TodayMenu(),
        plans = plans ?? const [],
        reviews = reviews ?? const [],
        tags = tags ?? const [];

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      id: json['_id'] as String? ?? json['id'] as String?,
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      cuisineType: (json['cuisineType'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      address: json['address'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      hygieneScore: (json['hygieneScore'] as num?)?.toInt() ?? 0,
      priceStartingAt: (json['priceStartingAt'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      image: json['image'] as String? ?? '',
      bannerImage: json['bannerImage'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      timings: json['timings'] as String? ?? '',
      todayMenu: json['todayMenu'] != null
          ? TodayMenu.fromJson(json['todayMenu'] as Map<String, dynamic>)
          : TodayMenu(),
      plans: (json['plans'] as List<dynamic>?)
              ?.map((e) => MessPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => MessReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'tagline': tagline,
      'cuisineType': cuisineType,
      'address': address,
      'distance': distance,
      'rating': rating,
      'totalReviews': totalReviews,
      'hygieneScore': hygieneScore,
      'priceStartingAt': priceStartingAt,
      'isVerified': isVerified,
      'image': image,
      'bannerImage': bannerImage,
      'ownerName': ownerName,
      'phone': phone,
      'timings': timings,
      'todayMenu': todayMenu.toJson(),
      'plans': plans.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'tags': tags,
    };
  }

  Mess copyWith({
    String? id,
    String? name,
    String? tagline,
    List<String>? cuisineType,
    String? address,
    String? distance,
    double? rating,
    int? totalReviews,
    int? hygieneScore,
    int? priceStartingAt,
    bool? isVerified,
    String? image,
    String? bannerImage,
    String? ownerName,
    String? phone,
    String? timings,
    TodayMenu? todayMenu,
    List<MessPlan>? plans,
    List<MessReview>? reviews,
    List<String>? tags,
  }) {
    return Mess(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      cuisineType: cuisineType ?? this.cuisineType,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      hygieneScore: hygieneScore ?? this.hygieneScore,
      priceStartingAt: priceStartingAt ?? this.priceStartingAt,
      isVerified: isVerified ?? this.isVerified,
      image: image ?? this.image,
      bannerImage: bannerImage ?? this.bannerImage,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      timings: timings ?? this.timings,
      todayMenu: todayMenu ?? this.todayMenu,
      plans: plans ?? this.plans,
      reviews: reviews ?? this.reviews,
      tags: tags ?? this.tags,
    );
  }
}

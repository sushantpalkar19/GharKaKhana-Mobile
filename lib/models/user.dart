class User {
  final String? id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String status;
  final String kycStatus;
  final bool isProfileCompleted;
  final bool isPasswordChanged;
  final String? profileImage;
  final String? address;
  final bool isVerified;
  final bool isActive;
  final List<String> bookmarks;
  final DateTime? createdAt;

  // Owner-specific fields
  final String? businessName;
  final String? businessAddress;
  final String? businessCity;
  final String? businessPincode;

  User({
    this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    this.status = 'active',
    this.kycStatus = 'not_started',
    this.isProfileCompleted = false,
    this.isPasswordChanged = false,
    this.profileImage,
    this.address,
    this.isVerified = false,
    this.isActive = true,
    List<String>? bookmarks,
    this.createdAt,
    this.businessName,
    this.businessAddress,
    this.businessCity,
    this.businessPincode,
  }) : bookmarks = bookmarks ?? const [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? json['id'] as String?,
      fullName: (json['fullName'] as String?) ?? (json['name'] as String?) ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'customer',
      status: json['status'] as String? ?? 'active',
      kycStatus: json['kycStatus'] as String? ?? 'not_started',
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
      isPasswordChanged: json['isPasswordChanged'] as bool? ?? false,
      profileImage: json['profileImage'] as String? ?? json['avatar'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      bookmarks: (json['bookmarks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      businessName: json['businessName'] as String?,
      businessAddress: json['businessAddress'] as String?,
      businessCity: json['businessCity'] as String?,
      businessPincode: json['businessPincode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'fullName': fullName,
      'email': email,
      if (phone != null) 'phone': phone,
      'role': role,
      'status': status,
      'kycStatus': kycStatus,
      'isProfileCompleted': isProfileCompleted,
      'isPasswordChanged': isPasswordChanged,
      if (profileImage != null) 'profileImage': profileImage,
      if (address != null) 'address': address,
      'isVerified': isVerified,
      'isActive': isActive,
      'bookmarks': bookmarks,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (businessName != null) 'businessName': businessName,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (businessCity != null) 'businessCity': businessCity,
      if (businessPincode != null) 'businessPincode': businessPincode,
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? status,
    String? kycStatus,
    bool? isProfileCompleted,
    bool? isPasswordChanged,
    String? profileImage,
    String? address,
    bool? isVerified,
    bool? isActive,
    List<String>? bookmarks,
    DateTime? createdAt,
    String? businessName,
    String? businessAddress,
    String? businessCity,
    String? businessPincode,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      kycStatus: kycStatus ?? this.kycStatus,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      isPasswordChanged: isPasswordChanged ?? this.isPasswordChanged,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      bookmarks: bookmarks ?? this.bookmarks,
      createdAt: createdAt ?? this.createdAt,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      businessCity: businessCity ?? this.businessCity,
      businessPincode: businessPincode ?? this.businessPincode,
    );
  }
}

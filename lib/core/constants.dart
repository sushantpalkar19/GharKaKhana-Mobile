import '../core/config/api_config.dart';
import '../models/mess.dart';
import '../models/subscription.dart';

class AppConstants {
  static String get apiBaseUrl => ApiConfig.baseUrl;

  static const String accessTokenKey = 'gharkakhana_access_token';
  static const String userKey = 'gharkakhana_user';

  static const String roleCustomer = 'customer';
  static const String roleOwner = 'owner';
  static const String roleAdmin = 'admin';

  static const List<String> roles = [
    roleCustomer,
    roleOwner,
    roleAdmin,
  ];

  static const String orderStatusActive = 'Active';
  static const String orderStatusPaused = 'Paused';
  static const String orderStatusExpired = 'Expired';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusUpcoming = 'Upcoming';

  static const List<String> orderStatuses = [
    orderStatusActive,
    orderStatusPaused,
    orderStatusExpired,
    orderStatusDelivered,
    orderStatusUpcoming,
  ];

  static const String mealTimeBreakfast = 'Breakfast';
  static const String mealTimeLunch = 'Lunch';
  static const String mealTimeDinner = 'Dinner';
  static const String mealTimeLunchDinner = 'Lunch & Dinner';
  static const String mealTimeFullDay = 'Full Day (B, L, D)';

  static const List<String> mealTimeOptions = [
    mealTimeBreakfast,
    mealTimeLunch,
    mealTimeDinner,
    mealTimeLunchDinner,
    mealTimeFullDay,
  ];

  static const String cuisineNorthIndian = 'North Indian';
  static const String cuisineSouthIndian = 'South Indian';
  static const String cuisinePureVeg = 'Pure Veg';
  static const String cuisineJain = 'Jain';
  static const String cuisineNonVeg = 'Non-Veg';
  static const String cuisineHighProtein = 'High Protein';
  static const String cuisineHomeStyle = 'Home-Style';
  static const String cuisineChettinad = 'Chettinad';
  static const String cuisineCentralIndian = 'North & Central Indian';
  static const String cuisineVegNonVeg = 'Veg & Non-Veg Options';

  static const List<String> cuisineFilters = [
    cuisineNorthIndian,
    cuisineSouthIndian,
    cuisinePureVeg,
    cuisineJain,
    cuisineNonVeg,
    cuisineHighProtein,
    cuisineHomeStyle,
    cuisineChettinad,
    cuisineCentralIndian,
    cuisineVegNonVeg,
  ];
}

class MockData {
  static final List<Mess> mockMesses = [
    Mess(
      id: 'm1',
      name: 'Annapurna Home Mess',
      tagline: 'Authentic North Indian Desi Ghee Thali',
      cuisineType: [
        AppConstants.cuisineNorthIndian,
        AppConstants.cuisinePureVeg,
        AppConstants.cuisineHomeStyle,
      ],
      address: 'Sector 62, Near Knowledge Park, Noida',
      distance: '0.8 km away',
      rating: 4.9,
      totalReviews: 480,
      hygieneScore: 99,
      priceStartingAt: 2499,
      isVerified: true,
      image:
          'https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?auto=format&fit=crop&w=800&q=80',
      bannerImage:
          'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=1200&q=80',
      ownerName: 'Sunita Sharma (Home Chef)',
      phone: '+91 98765 43210',
      timings: 'Lunch: 12:00 PM - 3:30 PM | Dinner: 7:30 PM - 10:30 PM',
      todayMenu: TodayMenu(
        breakfast: [
          'Poha with Fried Peanuts',
          'Adrak Masala Chai',
          'Boiled Sprouts',
        ],
        lunch: [
          'Paneer Butter Masala',
          'Yellow Dal Tadka',
          '4 Butter Phulkas',
          'Jeera Rice',
          'Gulab Jamun',
        ],
        dinner: [
          'Aloo Gobi Sukhi Sabzi',
          'Panchmel Dal',
          '4 Tawa Rotis',
          'Steamed Rice',
          'Fresh Cucumber Salad',
        ],
      ),
      plans: [
        MessPlan(
          id: 'p1',
          name: 'Standard Monthly (2 Meals/Day)',
          duration: 'Monthly',
          price: 3200,
          originalPrice: 4000,
          deliveriesPerDay: 2,
          includesSundaySpecial: true,
          features: [
            'Lunch & Dinner Daily',
            'Sunday Special Sweets & Choole Bhature',
            'Pause up to 5 days free',
            'Doorstep tiffin delivery',
          ],
          popular: true,
        ),
        MessPlan(
          id: 'p2',
          name: 'Weekly Trial Pack',
          duration: 'Weekly',
          price: 899,
          originalPrice: 1100,
          deliveriesPerDay: 2,
          includesSundaySpecial: false,
          features: [
            '7 Days Trial',
            'Lunch or Dinner choice',
            'Free Cancellation',
          ],
        ),
      ],
      reviews: [
        MessReview(
          id: 'r1',
          userName: 'Aman Verma',
          userRole: 'Software Engineer @ Tech Mahindra',
          avatar:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
          rating: 5,
          comment:
              'Reminds me of my mother\'s cooking in Lucknow! The dal tadka is divine and chapattis arrive steaming hot.',
          date: '2 days ago',
        ),
      ],
      tags: ['Best Seller', 'Desi Ghee', 'Free Delivery'],
    ),
    Mess(
      id: 'm2',
      name: 'Dakshin Kitchen Tiffins',
      tagline: 'Crispy Dosas, Idlis & Traditional South Indian Meals',
      cuisineType: [
        AppConstants.cuisineSouthIndian,
        AppConstants.cuisineChettinad,
        AppConstants.cuisinePureVeg,
      ],
      address: 'Koramangala 4th Block, Bengaluru',
      distance: '1.2 km away',
      rating: 4.8,
      totalReviews: 320,
      hygieneScore: 97,
      priceStartingAt: 2299,
      isVerified: true,
      image:
          'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
      bannerImage:
          'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=1200&q=80',
      ownerName: 'Lakshmi Narayan',
      phone: '+91 98123 45678',
      timings:
          'Breakfast: 7:30 AM - 10:30 AM | Lunch: 12:30 PM - 3:00 PM',
      todayMenu: TodayMenu(
        breakfast: [
          'Steamed Soft Idlis',
          'Crispy Medu Vada',
          'Coconut & Tomato Chutney',
          'Authentic Sambar',
        ],
        lunch: [
          'Traditional Banana Leaf Meals',
          'Sambar',
          'Rasam',
          'Poriyal',
          'Curd Rice',
          'Appalam',
        ],
        dinner: [
          'Ghee Roast Dosa',
          'Coconut Chutney',
          'Filter Coffee',
        ],
      ),
      plans: [
        MessPlan(
          id: 'p3',
          name: 'Full South Meal Monthly',
          duration: 'Monthly',
          price: 2999,
          originalPrice: 3600,
          deliveriesPerDay: 2,
          includesSundaySpecial: true,
          features: [
            'Breakfast + Lunch daily',
            'Filter Coffee included',
            'Reusable eco-tiffin containers',
          ],
          popular: true,
        ),
      ],
      reviews: [
        MessReview(
          id: 'r2',
          userName: 'Priya Iyer',
          userRole: 'MBA Student @ Christ Univ',
          avatar:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
          rating: 5,
          comment:
              'Pure nostalgia for anyone missing Tamil Nadu / Kerala food. Super hygienic and light on stomach!',
          date: 'Yesterday',
        ),
      ],
      tags: ['Banana Leaf Special', 'Authentic Sambar', 'Top Rated'],
    ),
    Mess(
      id: 'm3',
      name: 'Maa Ki Rasoi Tiffin Service',
      tagline: 'Homely Balanced Meal - Low Oil & High Protein Options',
      cuisineType: [
        AppConstants.cuisineCentralIndian,
        AppConstants.cuisineVegNonVeg,
      ],
      address: 'Viman Nagar, Pune',
      distance: '1.5 km away',
      rating: 4.9,
      totalReviews: 610,
      hygieneScore: 100,
      priceStartingAt: 2699,
      isVerified: true,
      image:
          'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
      bannerImage:
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=1200&q=80',
      ownerName: 'Sujata Deshmukh',
      phone: '+91 97654 32109',
      timings: 'Lunch: 12:00 PM - 3:00 PM | Dinner: 7:00 PM - 10:00 PM',
      todayMenu: TodayMenu(
        breakfast: [
          'Misal Pav with Farsan',
          'Adrak Chai',
        ],
        lunch: [
          'Homestyle Chicken Curry / Bhindi Masala',
          'Varan Bhaat',
          '4 Rotis',
          'Koshimbir',
        ],
        dinner: [
          'Egg Curry / Matar Paneer',
          'Chapatti',
          'Steam Rice',
          'Papad',
        ],
      ),
      plans: [
        MessPlan(
          id: 'p4',
          name: 'Pro Student Saver Plan',
          duration: 'Monthly',
          price: 2799,
          originalPrice: 3500,
          deliveriesPerDay: 2,
          includesSundaySpecial: true,
          features: [
            'Choice of Veg or Non-Veg 2x week',
            'Complimentary Dessert',
            'Pause anytime via App',
          ],
          popular: true,
        ),
      ],
      reviews: [
        MessReview(
          id: 'r3',
          userName: 'Rohan Sharma',
          userRole: 'PG Student @ Symbiosis',
          avatar:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
          rating: 5,
          comment:
              'Best meal service in Viman Nagar! Low oil, perfect spice levels, and always delivered right on time.',
          date: '3 days ago',
        ),
      ],
      tags: ['FSSAI Certified', 'High Protein', 'Student Choice'],
    ),
  ];

  static final List<SubscriptionOrder> mockSubscriptions = [
    SubscriptionOrder(
      id: 'ORD-84920',
      messId: 'm1',
      messName: 'Annapurna Home Mess',
      planName: 'Standard Monthly (2 Meals/Day)',
      startDate: '15 Jul 2026',
      expiryDate: '15 Aug 2026',
      status: AppConstants.orderStatusActive,
      amountPaid: 3200,
      mealTime: AppConstants.mealTimeLunchDinner,
    ),
    SubscriptionOrder(
      id: 'ORD-73194',
      messId: 'm2',
      messName: 'Dakshin Kitchen Tiffins',
      planName: 'Weekly Trial Pack',
      startDate: '01 Jul 2026',
      expiryDate: '08 Jul 2026',
      status: AppConstants.orderStatusDelivered,
      amountPaid: 899,
      mealTime: AppConstants.mealTimeFullDay,
    ),
  ];
}

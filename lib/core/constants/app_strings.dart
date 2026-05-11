class AppStrings {
  AppStrings._();

  static const String appName = 'FreshBasket';
  static const String appTagline = 'Farm Fresh, Delivered Daily';

  // Flutterwave — replace with real keys from dashboard
  static const String flwPublicKey = 'FLWPUBK-xxxxxxxxxxxxxxxxxxxxxxxxxxxx-X';
  static const String flwSecretKey = 'FLWSECK-xxxxxxxxxxxxxxxxxxxxxxxxxxxx-X';
  static const String flwEncryptionKey = 'YOUR_ENCRYPTION_KEY';

  // Google Maps — replace after enabling APIs
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Email SMTP
  static const String smtpUsername = 'freshbasketapp2024@gmail.com';
  static const String smtpPassword = 'tlvv vuau ghrf tpqy';

  // Onboarding
  static const String onboarding1Title = 'Shop Fresh, Delivered Fast';
  static const String onboarding1Subtitle =
      'Handpicked vegetables and fruits from local farms, delivered to your door in hours.';
  static const String onboarding2Title = 'Live Order Tracking';
  static const String onboarding2Subtitle =
      'Track your delivery in real time on the map. Know exactly when your produce arrives.';
  static const String onboarding3Title = 'Secure & Easy Checkout';
  static const String onboarding3Subtitle =
      'Pay with card or mobile money. Your transactions are always safe and encrypted.';

  // Auth
  static const String login = 'Sign In';
  static const String register = 'Create Account';
  static const String forgotPassword = 'Forgot Password?';
  static const String continueWithGoogle = 'Continue with Google';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String signOut = 'Sign Out';

  // Home
  static const String shopByCategory = 'Shop by Category';
  static const String featuredProducts = 'Featured Products';
  static const String bestSellers = 'Best Sellers';
  static const String seeAll = 'See All';

  // Categories
  static const List<String> categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Organic',
    'Seasonal',
  ];

  // Cart
  static const String myCart = 'My Cart';
  static const String cartEmpty = 'Your cart is empty';
  static const String cartEmptySubtitle = 'Add fresh produce to get started';
  static const String proceedToCheckout = 'Proceed to Checkout';
  static const String promoCode = 'Promo Code';
  static const String apply = 'Apply';
  static const String subtotal = 'Subtotal';
  static const String deliveryFee = 'Delivery Fee';
  static const String discount = 'Discount';
  static const String total = 'Total';

  // Checkout
  static const String deliveryAddress = 'Delivery Address';
  static const String selectTimeSlot = 'Select Time Slot';
  static const String payment = 'Payment';
  static const String orderConfirmed = 'Order Confirmed!';
  static const String trackOrder = 'Track Order';
  static const String continueShopping = 'Continue Shopping';
  static const String payWithCard = 'Pay with Card';
  static const String payWithMobileMoney = 'Mobile Money';

  // Orders
  static const String myOrders = 'My Orders';
  static const String orderDetails = 'Order Details';
  static const String reorder = 'Reorder';
  static const String noOrders = 'No orders yet';
  static const String noOrdersSubtitle = 'Your past orders will appear here';

  // Profile
  static const String myProfile = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String savedAddresses = 'Saved Addresses';
  static const String paymentMethods = 'Payment Methods';
  static const String notifications = 'Notifications';
  static const String helpSupport = 'Help & Support';

  // Status
  static const String placed = 'Placed';
  static const String preparing = 'Preparing';
  static const String dispatched = 'Out for Delivery';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';

  // Freshness
  static const String fresh = 'Fresh';
  static const String good = 'Good';
  static const String limited = 'Limited';

  // Error messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection. Check your network.';
  static const String invalidEmail = 'Enter a valid email address.';
  static const String weakPassword = 'Password must be at least 8 characters.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String fieldRequired = 'This field is required.';
  static const String invalidPhone = 'Enter a valid phone number.';
}

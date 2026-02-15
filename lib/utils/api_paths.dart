class ApiPaths {
  // users
  static String users(String userId) => 'users/$userId';
  static String cartItem(String userId, String cartItemId) =>
      'users/$userId/cart/$cartItemId';

  // payment methods
  static String paymentCard(String userId, String cardId) =>
      'users/$userId/payment_methods/$cardId';
  static String paymentCards(String userId) => 'users/$userId/payment_methods';
  // products and categories
  static String products() => 'products/';
  static String product(String productId) => 'products/$productId';
  static String categories() => 'categories/';
  // announcments
  static String announcment() => 'announcment/';
  // fevorites
  static String fevoriteProduct(String userId, String productId) =>
      'users/$userId/fevorites/$productId';

  static String fevoritesProducts(String userId) => 'users/$userId/fevorites';
  // cart items
  static String cartItems(String userId) => 'users/$userId/cart';

  // location
  static String location(String userId, String locationId) =>
      'users/$userId/locations/$locationId';

  static String locations(String userId) => 'users/$userId/locations/';
}

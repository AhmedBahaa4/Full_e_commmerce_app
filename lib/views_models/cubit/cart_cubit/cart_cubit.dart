import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/cart_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// part 'cart_state.dart';

// class CartCubit extends Cubit<CartState> {
//   CartCubit() : super(CartInitial());

//   int quantity = 1;
//   final cartsrvices = CartServicesImpl();
//   final authServices = AuthServicesImpl();

//   /// 🔹 تحميل العناصر من السلة
//   Future<void> getCartItems() async {
//     emit(CartLoading());
//     try {
//       final userId = authServices.currentUser()!.uid;
//       final cartItems = await cartsrvices.getCartItems(userId);

//       final double subTotal = cartItems.fold(
//         0.0,
//         (previousValue, element) =>
//             previousValue + element.product.price * element.quantity,
//       );

//       final double shipping = subTotal * 0.25;

//       emit(CartLoaded(cartItems, subTotal, shipping));
//       emit(SubTotalUpdated(subTotal: subTotal, shipping: shipping));
//     } catch (e) {
//       emit(CartError(message: e.toString()));
//     }
//   }

//   /// 🔹 زيادة الكمية
//   void incrementCounter(String productId, [int? initialValue]) {
//     if (initialValue != null) quantity = initialValue;
//     quantity++;

//     dummyCart[index] = dummyCart[index].copyWith(quantity: quantity);

//     emit(QuantityCounterLoaded(value: quantity, productId: productId));
//     emit(SubTotalUpdated(subTotal: _subtotal, shipping: _subtotal * 0.25));
//   }

//   /// 🔹 تقليل الكمية
//   void decrementCounter(String productId, [int? initialValue]) {
//     if (quantity > 1) {
//       if (initialValue != null) quantity = initialValue;
//       quantity--;

//       final index =
//           dummyCart.indexWhere((item) => item.product.id == productId);
//       if (index == -1) return;

//       dummyCart[index] = dummyCart[index].copyWith(quantity: quantity);

//       emit(QuantityCounterLoaded(value: quantity, productId: productId));
//       emit(SubTotalUpdated(subTotal: _subtotal, shipping: _subtotal * 0.25));
//     }
//   }

//   /// 🔹 حساب المجموع الفرعي
//   double get _subtotal => dummyCart.fold<double>(
//         0,
//         (previousValue, item) =>
//             previousValue + (item.product.price * item.quantity),
//       );
// }
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  List<AddToCartModel> cartItems = [];

  /// تحميل السلة
  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final userId = authServices.currentUser()!.uid;
      cartItems = await cartServices.fetchCartItems(userId);

      emit(CartLoaded(cartItems, _subtotal, _shipping));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  /// زيادة الكمية
  void incrementCounter(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.product.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    final updated = item.copyWith(quantity: item.quantity + 1);

    cartItems[index] = updated;

    emit(QuantityCounterLoaded(value: updated.quantity, productId: cartItemId));
    emit(SubTotalUpdated(subTotal: _subtotal, shipping: _shipping));
  }

  /// تقليل الكمية
  void decrementCounter(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.product.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    if (item.quantity == 1) return;

    final updated = item.copyWith(quantity: item.quantity - 1);

    cartItems[index] = updated;

    emit(QuantityCounterLoaded(value: updated.quantity, productId: cartItemId));
    emit(SubTotalUpdated(subTotal: _subtotal, shipping: _shipping));
  }

  double get _subtotal {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.quantity * item.product.price),
    );
  }

  double get _shipping => _subtotal * 0.25;
}

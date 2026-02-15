import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/cart_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  List<AddToCartModel> cartItems = [];

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        cartItems = [];
        emit(CartLoaded(cartItems, 0, 0));
        return;
      }

      cartItems = await cartServices.fetchCartItems(currentUser.uid);
      emit(CartLoaded(cartItems, _subtotal, _shipping));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  void incrementCounter(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    final updated = item.copyWith(quantity: item.quantity + 1);
    cartItems[index] = updated;

    emit(
      QuantityCounterLoaded(
        value: updated.quantity,
        productId: updated.product.id,
      ),
    );
    emit(SubTotalUpdated(subTotal: _subtotal, shipping: _shipping));
  }

  void decrementCounter(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    if (item.quantity == 1) return;

    final updated = item.copyWith(quantity: item.quantity - 1);
    cartItems[index] = updated;

    emit(
      QuantityCounterLoaded(
        value: updated.quantity,
        productId: updated.product.id,
      ),
    );
    emit(SubTotalUpdated(subTotal: _subtotal, shipping: _shipping));
  }

  double get _subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item.quantity * item.product.price),
  );

  double get _shipping => _subtotal * 0.25;
}

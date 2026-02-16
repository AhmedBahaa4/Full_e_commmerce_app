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

  Future<void> getCartItems({bool showLoading = true}) async {
    if (showLoading || state is! CartLoaded) {
      emit(CartLoading());
    }

    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        cartItems = [];
        _emitLoaded();
        return;
      }

      cartItems = await cartServices.fetchCartItems(currentUser.uid);

      cartItems = cartItems.where((item) => item.id.isNotEmpty).toList();
      _emitLoaded();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> incrementCounter(String cartItemId) async {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    final updated = item.copyWith(quantity: item.quantity + 1);
    cartItems[index] = updated;
    _emitLoaded();
    await _syncItem(updated, fallback: item, index: index);
  }

  Future<void> decrementCounter(String cartItemId) async {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    if (item.quantity == 1) {
      await removeCartItem(cartItemId);
      return;
    }

    final updated = item.copyWith(quantity: item.quantity - 1);
    cartItems[index] = updated;
    _emitLoaded();
    await _syncItem(updated, fallback: item, index: index);
  }

  Future<void> removeCartItem(String cartItemId) async {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final removed = cartItems[index];
    cartItems.removeAt(index);
    _emitLoaded();

    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      cartItems.insert(index, removed);
      _emitLoaded();
      return;
    }

    try {
      await cartServices.deleteCartItem(currentUser.uid, cartItemId);
    } catch (_) {
      cartItems.insert(index, removed);
      _emitLoaded();
    }
  }

  Future<void> _syncItem(
    AddToCartModel updated, {
    required AddToCartModel fallback,
    required int index,
  }) async {
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      cartItems[index] = fallback;
      _emitLoaded();
      return;
    }

    try {
      await cartServices.setCartItem(currentUser.uid, updated);
    } catch (_) {
      cartItems[index] = fallback;
      _emitLoaded();
    }
  }

  void _emitLoaded() {
    emit(CartLoaded(List.unmodifiable(cartItems), _subtotal, _shipping));
  }

  double get _subtotal =>
      cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);

  double get _shipping => _subtotal * 0.25;
}

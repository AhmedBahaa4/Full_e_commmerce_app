import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/product_details_services.dart';

part 'product_deails_state.dart';

class ProductDeailsCubit extends Cubit<ProductDeailsState> {
  ProductDeailsCubit() : super(ProductDeailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;
  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  /// تحميل بيانات المنتج
  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );

      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  /// اختيار المقاس
  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  /// إضافة للسلة
  Future<void> addToCart(String productId) async {
    emit(ProductAddingToCart());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        productId,
      );

      final currentUser = authServices.currentUser();

      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: selectedSize!,
        quantity: quantity,
      );

      await productDetailsServices.addTocart(cartItem, currentUser!.uid);

      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      emit(ProductAddedToCartError(message: e.toString()));
    }
  }

  /// + زيادة العدد
  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity));
  }

  /// - تقليل العدد
  void decrementCounter(String productId) {
    if (quantity > 1) {
      quantity--;
      emit(QuantityCounterLoaded(value: quantity));
    }
  }
}

List<AddToCartModel> dummyAddToCartItems = [];

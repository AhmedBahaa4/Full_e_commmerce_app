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
  ProductItemModel? _loadedProduct;
  ProductItemModel? get loadedProduct => _loadedProduct;
  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  /// تحميل بيانات المنتج
  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        id,
      );
      _loadedProduct = selectedProduct;
      selectedSize = null;
      quantity = 1;

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
    final size = selectedSize;
    if (size == null) {
      emit(ProductAddedToCartError(message: 'Please select a size first.'));
      return;
    }

    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(ProductAddedToCartError(message: 'Please login first.'));
      return;
    }

    emit(ProductAddingToCart());
    try {
      final selectedProduct = _loadedProduct?.id == productId
          ? _loadedProduct!
          : await productDetailsServices.fetchProductDetails(productId);

      final cartItem = AddToCartModel(
        id: '${productId}_${size.name}_${DateTime.now().microsecondsSinceEpoch}',
        product: selectedProduct,
        size: size,
        quantity: quantity,
      );

      await productDetailsServices.addTocart(cartItem, currentUser.uid);

      quantity = 1;
      emit(ProductAddedToCart(productId: productId));
      emit(ProductDetailsLoaded(product: selectedProduct));
    } catch (e) {
      emit(ProductAddedToCartError(message: e.toString()));
      final selectedProduct = _loadedProduct;
      if (selectedProduct != null) {
        emit(ProductDetailsLoaded(product: selectedProduct));
      }
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

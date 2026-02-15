import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);
  Future<void> addTocart(AddToCartModel cartItem, String userId);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    final selsctedProduct = await firestoreServices
        .getDocument<ProductItemModel>(
          path: ApiPaths.product(productId),
          builder: (data, documentID) => ProductItemModel.fromMap(data),
        );

    return selsctedProduct;
  }

  @override
  Future<void> addTocart(AddToCartModel cartItem, String userId) async =>
      await firestoreServices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );
}

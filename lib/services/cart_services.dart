import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
  Future<void> setCartItem(String userId, AddToCartModel cartItem);
  Future<void> deleteCartItem(String userId, String cartItemId);
}

class CartServicesImpl implements CartServices {
  final firestoreservices = FirestoreServices.instance;
  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await firestoreservices.getCollection<AddToCartModel>(
        path: ApiPaths.cartItems(userId),
        builder: (data, documentId) =>
            AddToCartModel.fromMap(data, documentId: documentId),
      );

  @override
  Future<void> setCartItem(String userId, AddToCartModel cartItem) async =>
      await firestoreservices.setData(
        path: ApiPaths.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );

  @override
  Future<void> deleteCartItem(String userId, String cartItemId) async =>
      await firestoreservices.deleteData(
        path: ApiPaths.cartItem(userId, cartItemId),
      );
}

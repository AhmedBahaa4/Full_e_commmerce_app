import 'package:e_commerc_app/models/category_model.dart';
import 'package:e_commerc_app/models/home_carousel_item_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';

abstract class HomeServices {
  Future<List<ProductItemModel>> fetchProducts();
  Future<List<HomeCarouselItemModel>> fetchHomeCarouselItems();
  Future<List<CategoryModel>> fetchCategories();
}

class HomeServicesImpl implements HomeServices {
  final firestoreServices = FirestoreServices.instance;
  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    return await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    return await firestoreServices.getCollection<CategoryModel>(
      path: ApiPaths.categories(),
      builder: (data, documentId) => CategoryModel.fromMap(data),
    );
  }

  @override
  Future<List<HomeCarouselItemModel>> fetchHomeCarouselItems() async {
    return await firestoreServices.getCollection<HomeCarouselItemModel>(
      path: ApiPaths.announcment(),
      builder: (data, documentId) => HomeCarouselItemModel.fromMap(data),
    );
  }
}

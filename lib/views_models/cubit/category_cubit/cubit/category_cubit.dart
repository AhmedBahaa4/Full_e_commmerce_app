import 'package:e_commerc_app/models/category_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/home_services.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final _homeServices = HomeServicesImpl();

  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final categoriesFromDb = await _homeServices.fetchCategories();
      final products = await _homeServices.fetchProducts();

      final mergedCategories = _buildMergedCategories(
        categoriesFromDb,
        products,
      );

      emit(CategoryLoaded(categories: mergedCategories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  List<CategoryModel> _buildMergedCategories(
    List<CategoryModel> dbCategories,
    List<ProductItemModel> products,
  ) {
    final productCounts = <String, int>{};
    for (final product in products) {
      final categoryName = product.category.trim();
      if (categoryName.isEmpty) continue;
      productCounts[categoryName] = (productCounts[categoryName] ?? 0) + 1;
    }

    final dbByKey = <String, CategoryModel>{};
    for (final category in dbCategories) {
      dbByKey[_normalize(category.name)] = category;
    }

    final merged = <CategoryModel>[];

    if (products.isNotEmpty) {
      final dbNewArrivals = dbByKey[_normalize('New Arrivals')];
      merged.add(
        CategoryModel(
          id: dbNewArrivals?.id.isNotEmpty == true
              ? dbNewArrivals!.id
              : 'new_arrivals',
          name: 'New Arrivals',
          productsCount: products.length,
          bgColor: dbNewArrivals?.bgColor ?? AppColors.black,
          textcolor: dbNewArrivals?.textcolor ?? AppColors.white,
          imageUrl: dbNewArrivals?.imageUrl,
        ),
      );
    }

    final sortedProductCategories = productCounts.keys.toList()..sort();

    for (var i = 0; i < sortedProductCategories.length; i++) {
      final name = sortedProductCategories[i];
      final key = _normalize(name);
      if (key == _normalize('New Arrivals')) continue;

      final dbCategory = dbByKey[key];
      final bgColor = dbCategory?.bgColor ?? _fallbackColor(i);

      merged.add(
        CategoryModel(
          id: dbCategory?.id.isNotEmpty == true ? dbCategory!.id : key,
          name: name,
          productsCount: productCounts[name] ?? 0,
          bgColor: bgColor,
          textcolor:
              dbCategory?.textcolor ??
              _fallbackTextColorFor(background: bgColor),
          imageUrl: dbCategory?.imageUrl,
        ),
      );
    }

    for (final dbCategory in dbCategories) {
      final key = _normalize(dbCategory.name);
      final alreadyAdded = merged.any((item) => _normalize(item.name) == key);
      if (alreadyAdded || dbCategory.name.trim().isEmpty) continue;

      merged.add(
        CategoryModel(
          id: dbCategory.id,
          name: dbCategory.name,
          productsCount: dbCategory.productsCount,
          bgColor: dbCategory.bgColor,
          textcolor: dbCategory.textcolor,
          imageUrl: dbCategory.imageUrl,
        ),
      );
    }

    return merged;
  }

  String _normalize(String input) => input.trim().toLowerCase();

  Color _fallbackColor(int index) {
    const palette = <Color>[
      Color(0xFF1F2937),
      Color(0xFF0F766E),
      Color(0xFF1D4ED8),
      Color(0xFF9A3412),
      Color(0xFF5B21B6),
    ];
    return palette[index % palette.length];
  }

  Color _fallbackTextColorFor({required Color background}) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? AppColors.white : AppColors.black;
  }
}

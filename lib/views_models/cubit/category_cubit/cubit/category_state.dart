part of 'category_cubit.dart';


sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoaded({required this.categories});
}
final class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});
}
import 'package:e_commerc_app/models/category_model.dart';
import 'package:e_commerc_app/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final _homeServices = HomeServicesImpl();

  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _homeServices.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      // لو عايز تعمل error state ممكن نضيفه بعدين
      emit(CategoryError(message: e.toString()));
    }
  }
}

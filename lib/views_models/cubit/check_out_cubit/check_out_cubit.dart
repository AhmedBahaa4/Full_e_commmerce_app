import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/cart_services.dart';
import 'package:e_commerc_app/services/checkout_services.dart';
import 'package:e_commerc_app/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(CheckOutInitial());
  // services
  // to get checkout content
  final checkOutServices = CheckoutServicesImpl();
  final authservices = AuthServicesImpl();
  // to get locations from firebase
  final locationServices = LocationServicesImpl();
  // get cart content
  final cartServices = CartServicesImpl();

  Future<void> getCheckoutContent() async {
    emit(CheckOutLoading());

    try {
      final currentUser = authservices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
      final subtotal = cartItems.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.product.price * element.quantity,
      );
      final numberOfProducts = cartItems.fold(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

      final choosenpaymentCards = (await checkOutServices.fetchPaymentMethods(
        currentUser.uid,
        true,
      )).first;
      // get choosen address
      final chosenAdress = (await locationServices.fetchLocations(
        currentUser.uid,
        isChoosen: true,
      )).first;
      emit(
        CheckOutLoaded(
          cartItems: cartItems,
          totalAmount: subtotal + 10,
          numberOfProducts: numberOfProducts,
          choosenpaymentCard: choosenpaymentCards,
          chosenAdress: chosenAdress,
        ),
      );
    } catch (e) {
      emit(CheckOutError(message: e.toString()));
    }
  }
}

import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/checkout_services.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_method_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  String? selectedPaymentId;
  final checkOutServices = CheckoutServicesImpl();
  final firestoreservices = FirestoreServices.instance;
  final authservices = AuthServicesImpl();

  Future<void> addNewCard(
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  ) async {
    emit(AddNewCardLoading());
    try {
      final currentUser = authservices.currentUser();
      if (currentUser == null) {
        emit(AddNewCardFailure('You need to login first'));
        return;
      }

      final chosenCards = await checkOutServices.fetchPaymentMethods(
        currentUser.uid,
        true,
      );
      final newcard = PaymentCardModel(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        cardHolderName: cardHolderName,
        id: DateTime.now().toIso8601String(),
        ischoosen: chosenCards.isEmpty,
      );

      await checkOutServices.setCard(newcard, currentUser.uid);

      emit(AddNewCardSuccess());
    } catch (e) {
      emit(AddNewCardFailure(e.toString()));
    }
  }
  // Fetch Payment Methods

  Future<void> fetchPaymentMethods() async {
    emit(FetchingPaymentMethods());

    try {
      final currentUser = authservices.currentUser();
      if (currentUser == null) {
        emit(FetchedPaymentMethodsFailure('You need to login first'));
        return;
      }
      final paymentCrds = await checkOutServices.fetchPaymentMethods(
        currentUser.uid,
      );
      emit(FetchedPaymentMethodss(paymentCrds));

      if (paymentCrds.isNotEmpty) {
        final chosenPaymentMethod = paymentCrds.firstWhere(
          (card) => card.ischoosen,
          orElse: () => paymentCrds.first,
        );
        selectedPaymentId = chosenPaymentMethod.id;

        emit(PaymentMethodChosen(chosenPaymentMethod));
      }
    } catch (e) {
      emit(FetchedPaymentMethodsFailure(e.toString()));
    }
  }
  // Change Payment Method

  Future<void> changePaymentMethod(String id) async {
    try {
      selectedPaymentId = id;
      final currentUser = authservices.currentUser();
      if (currentUser == null) {
        emit(FetchedPaymentMethodsFailure('You need to login first'));
        return;
      }

      final tempchosenPaymentMethod = await checkOutServices
          .fetchSinglePaymentMethod(currentUser.uid, selectedPaymentId!);
      emit(PaymentMethodChosen(tempchosenPaymentMethod));
    } catch (e) {
      emit(FetchedPaymentMethodsFailure(e.toString()));
    }
  }

  // Confirm Payment
  Future<void> confirmPaymentMethod() async {
    emit(ConfirmPaymentLoading());
    try {
      final currentUser = authservices.currentUser();
      if (currentUser == null) {
        emit(ConfirmPaymentFailure('You need to login first'));
        return;
      }
      if (selectedPaymentId == null || selectedPaymentId!.isEmpty) {
        emit(ConfirmPaymentFailure('Please choose a payment method'));
        return;
      }

      final previousChoosenPayment = await checkOutServices.fetchPaymentMethods(
        currentUser.uid,
        true,
      );
      var chosenPaymentMethod = await checkOutServices.fetchSinglePaymentMethod(
        currentUser.uid,
        selectedPaymentId!,
      );
      chosenPaymentMethod = chosenPaymentMethod.copyWith(ischoosen: true);
      if (previousChoosenPayment.isNotEmpty &&
          previousChoosenPayment.first.id != chosenPaymentMethod.id) {
        final previousChoosenPaymentMethod = previousChoosenPayment.first
            .copyWith(ischoosen: false);
        await checkOutServices.setCard(
          previousChoosenPaymentMethod,
          currentUser.uid,
        );
      }
      await checkOutServices.setCard(chosenPaymentMethod, currentUser.uid);

      emit(PaymentMethodChosen(chosenPaymentMethod));
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailure(e.toString()));
    }
  }
}

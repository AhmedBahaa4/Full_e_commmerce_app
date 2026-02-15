part of 'payment_method_cubit.dart';

sealed class PaymentMethodsState {}

final class PaymentMethodsInitial extends PaymentMethodsState {}

final class AddNewCardLoading extends PaymentMethodsState {}

final class AddNewCardSuccess extends PaymentMethodsState {}

final class AddNewCardFailure extends PaymentMethodsState {
  final String message;
  AddNewCardFailure(this.message);
}

final class FetchingPaymentMethods extends PaymentMethodsState {}

final class FetchedPaymentMethodss extends PaymentMethodsState {
  final List<PaymentCardModel> paymentCards;
  FetchedPaymentMethodss(this.paymentCards);
}

final class FetchedPaymentMethodsFailure extends PaymentMethodsState {
  final String errorMessage;
  FetchedPaymentMethodsFailure(this.errorMessage);
}

final class PaymentMethodChosen extends PaymentMethodsState {
  final PaymentCardModel chosenPayment;
  PaymentMethodChosen(this.chosenPayment);
}

final class ConfirmPaymentLoading extends PaymentMethodsState {}

final class ConfirmPaymentSuccess extends PaymentMethodsState {}

final class ConfirmPaymentFailure extends PaymentMethodsState {
  final String message;
  ConfirmPaymentFailure(this.message);
}

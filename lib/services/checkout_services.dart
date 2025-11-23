import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';

abstract class CheckoutServices {
  Future<void> setCard(PaymentCardModel paymentCard, String userId);
  Future<List<PaymentCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]);
  Future<PaymentCardModel> fetchSinglePaymentMethod(
    String userId,
    String paymentId,
  );
}

class CheckoutServicesImpl implements CheckoutServices {
  final firestoreservices = FirestoreServices.instance;

  @override
  Future<void> setCard(PaymentCardModel paymentCard, String userId) async {
    return await firestoreservices.setData(
      path: ApiPaths.paymentCard(userId, paymentCard.id),
      data: paymentCard.toMap(),
    );
  }

  @override
  Future<List<PaymentCardModel>> fetchPaymentMethods(
    String userId, [
    bool chosen = false,
  ]) async {
    return await firestoreservices.getCollection<PaymentCardModel>(
      path: ApiPaths.paymentCards(userId),
      builder: (data, documentId) => PaymentCardModel.fromMap(data),
      queryBuilder: chosen
          ? (query) => query.where('ischoosen', isEqualTo: true)
          : null,
    );
  }

  @override
  Future<PaymentCardModel> fetchSinglePaymentMethod(
    String userId,
    String paymentId,
  ) async {
    return await firestoreservices.getDocument<PaymentCardModel>(
      path: ApiPaths.paymentCard(userId, paymentId),
      builder: (data, documentId) => PaymentCardModel.fromMap(data),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final bool ischoosen;

  PaymentCardModel({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.id,
    this.ischoosen = false,
  });

  PaymentCardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    bool? ischoosen,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      ischoosen: ischoosen ?? this.ischoosen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'ischoosen': ischoosen,
    };
  }

  factory PaymentCardModel.fromMap(Map<String, dynamic> map) {
    return PaymentCardModel(
      id: map['id'] as String,
      cardNumber: map['cardNumber'] as String,
      cardHolderName: map['cardHolderName'] as String,
      expiryDate: map['expiryDate'] as String,
      cvv: map['cvv'] as String,
      ischoosen: map['ischoosen'] as bool,
    );
  }
}

// to simulate the backend
List<PaymentCardModel> dummyPaymentCards = [
  PaymentCardModel(
    id: '1',
    cardNumber: '1234567812345678',
    cardHolderName: 'John Doe',
    expiryDate: '12/24',
    cvv: '123',
  ),
  PaymentCardModel(
    id: '2',
    cardNumber: '8765432187654321',
    cardHolderName: 'Jane Smith',
    expiryDate: '11/23',
    cvv: '456',
  ),
  PaymentCardModel(
    id: '3',
    cardNumber: '1111222233334444',
    cardHolderName: 'Alice Johnson',
    expiryDate: '10/25',
    cvv: '789',
  ),
  PaymentCardModel(
    id: '4',
    cardNumber: '4444333322221111',
    cardHolderName: 'Bob Brown',
    expiryDate: '09/22',
    cvv: '012',
  ),
  PaymentCardModel(
    id: '5',
    cardNumber: '9999888877776666',
    cardHolderName: 'Charlie Davis',
    expiryDate: '08/21',
    cvv: '345',
  ),
  PaymentCardModel(
    id: '6',
    cardNumber: '6666555544443333',
    cardHolderName: 'Eve Wilson',
    expiryDate: '07/20',
    cvv: '678',
  ),
];

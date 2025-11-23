// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:e_commerc_app/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final ProductSize size;
  final  int  quantity;

  AddToCartModel({
    required this.id,
    required this.size,
    required this.quantity,
    required this.product,
   
  });

   double get totalPrice => product.price * quantity;

 

  AddToCartModel copyWith({
    String? id,
    ProductItemModel? product,
    ProductSize? size,
    int? quantity,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.toMap(),
    'size': size.toShortString(),
      'quantity': quantity,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'] as String,
      product: ProductItemModel.fromMap(map['product'] ),
size: ProductSize.fromString(map['size'] ),
      quantity: map['quantity'] as int,
    );
  }


  }


// Dummy cart list
List<AddToCartModel> dummyCart = [];

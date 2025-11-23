// import 'package:e_commerc_app/models/add_to_cart_model.dart';
// import 'package:e_commerc_app/utils/app_color.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class CounterWidget extends StatelessWidget {
//   final int value;
//   final String? productId;
//   final AddToCartModel? cartItem;
//   final dynamic cubit;
//   final int? initialValue;

//   const CounterWidget({
//     super.key,
//     required this.value,
//     this.productId,
//     required this.cubit,
//     this.initialValue,
//     this.cartItem,
//   }) : assert(
//          productId != null || cartItem != null,
//          'Either productId or cartItem must be provided',
//        );

//   Future<void> decrementCounter() async {
//     if (initialValue != null) {
//       cubit.decrementCounter(productId, initialValue);
//     } else {
//       cubit.decrementCounter(productId!, initialValue);
//     }
//   }
//   Future<void> incrementCounter( {AddToCartModel? cartItem , String? productId} ) async {
//     if (initialValue != null) {
//      await  cubit.incrementCounter(productId, initialValue);
//     } else {
//      await  cubit.incrementCounter(productId!, initialValue);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.grey),
//         borderRadius: BorderRadius.circular(50),
//         color: AppColors.greyshade,
//         shape: BoxShape.rectangle,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         child: Row(
//           children: [
//             IconButton(
//               onPressed: () =>   cartItem != null
//                   ? decrementCounter( cartItem : cartItem)
//                   : decrementCounter( productId : productId), // ✅ هنا التعديل
//               icon: const CircleAvatar(
//                 backgroundColor: AppColors.white,
//                 radius: 12,
//                 child: Icon(Icons.remove),
//               ),
//             ),
//             Text(
//               value.toString(),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               onPressed: () => initialValue != null
//                   ? cubit.incrementCounter(productId, initialValue)
//                   : cubit.incrementCounter(productId), // ✅ هنا التعديل
//               icon: const CircleAvatar(
//                 backgroundColor: AppColors.white,
//                 radius: 12,
//                 child: Icon(Icons.add),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

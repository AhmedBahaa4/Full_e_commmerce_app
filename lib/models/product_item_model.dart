enum ProductSize {
  S,
  M,
  L,
  // ignore: constant_identifier_names
  XL,
  // ignore: constant_identifier_names
  XXL;

  static ProductSize fromString(String size) {
    switch (size.toUpperCase()) {
      case 'S':
        return ProductSize.S;
      case 'M':
        return ProductSize.M;
      case 'L':
        return ProductSize.L;
      case 'XL':
        return ProductSize.XL;
      case 'XXL':
        return ProductSize.XXL;
      default:
        return ProductSize.M;
    }
  }

  String toShortString() => name;
}

class ProductItemModel {
  final String name;
  final String id;
  final String imgUrl;
  final String description;
  final bool isFavorite;
  final double price;
  final String category;
  final double averageRate;

  ProductItemModel({
    required this.category,
    required this.name,
    required this.id,
    required this.imgUrl,
    this.description =
        'Lorem ipsum dolor sit amet consectetur adipiscing elit ullamcorper dictumst euismod.lorem ipsum dolor sit amet consectetur adipiscing elit ullamcorper dictumst euismod.lo',
    required this.price,
    this.isFavorite = false,
    this.averageRate = 4.5,
  });

  /// ✅ copyWith
  ProductItemModel copyWith({
    String? name,
    String? id,
    String? imgUrl,
    String? description,
    bool? isFavorite,
    double? price,
    String? category,
    double? averageRate,
  }) {
    return ProductItemModel(
      name: name ?? this.name,
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      price: price ?? this.price,
      category: category ?? this.category,
      averageRate: averageRate ?? this.averageRate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'imgUrl': imgUrl,
      'description': description,
      // 'isFavorite': isFavorite,
      'price': price,
      'category': category,
      'averageRate': averageRate,
    };
  }

factory ProductItemModel.fromMap(Map<String, dynamic> map) {
  return ProductItemModel(
    name: map['name'] ?? '',
    id: map['id'] ?? '',
    imgUrl: map['imgUrl'] ?? '',
    description: map['description'] ?? '',
    price: (map['price'] as num?)?.toDouble() ?? 0.0,
    category: map['category'] ?? '',
    averageRate: (map['averageRate'] as num?)?.toDouble() ?? 0.0,
  );
}
}

List<ProductItemModel> dummyProducts = [
  ProductItemModel(
    id: 'K434118okA3XH70vmCgI',
    name: 'Black Shoes',
    imgUrl: 'https://pngimg.com/d/men_shoes_PNG7475.png',
    price: 20,
    category: 'Shoes',
  ),
  ProductItemModel(
    id: '3p6nOiAbCwlKNZkme7t2',
    name: 'Trousers',
    imgUrl:
        'https://www.pngall.com/wp-content/uploads/2016/09/Trouser-Free-Download-PNG.png',
    price: 30,
    category: 'Clothes',
  ),
  ProductItemModel(
    id: 'Y4xM7ukLvqRsurgioQmN',
    name: 'Pack of Tomatoes',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/12/tomatopng.parspng.com-6.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: 'OHncCKAImAwC9jg9XPam',
    name: 'Pack of Potatoes',
    imgUrl: 'https://pngimg.com/d/potato_png2398.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: '7WqSYwiEbed0G05zM72u',
    name: 'Pack of Onions',
    imgUrl: 'https://pngimg.com/d/onion_PNG99213.png',
    price: 10,
    category: 'Groceries',
  ),
  ProductItemModel(
    id: 'NQwKrejnxOFcgAzdkoQm',
    name: 'Pack of Apples',
    imgUrl: 'https://pngfre.com/wp-content/uploads/apple-43-1024x1015.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: 'uIVHYv1tLpiC3Jwik8b0',
    name: 'Pack of Oranges',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/05/orangepng.parspng.com_-1.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: 'BOQKlAc0GlRZXOmzcs1l',
    name: 'Pack of Bananas',
    imgUrl:
        'https://static.vecteezy.com/system/resources/previews/015/100/096/original/bananas-transparent-background-free-png.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: 'atZHZfhF5glVKKO3XCtz',
    name: 'Pack of Mangoes',
    imgUrl: 'https://purepng.com/public/uploads/large/mango-tgy.png',
    price: 10,
    category: 'Fruits',
  ),
  ProductItemModel(
    id: 'jXDJxAUnBWJTXrOn5V1n',
    name: 'Sweet Shirt',
    imgUrl:
        'https://www.usherbrand.com/cdn/shop/products/5uYjJeWpde9urtZyWKwFK4GHS6S3thwKRuYaMRph7bBDyqSZwZ_87x1mq24b2e7_1800x1800.png',
    price: 15,
    category: 'Clothes',
  ),
  ProductItemModel(
    id: 'PjORGdvg4dVIxnVjjhgB',
    name: 'T-shirt',
    imgUrl:
        'https://parspng.com/wp-content/uploads/2022/07/Tshirtpng.parspng.com_.png',
    price: 10,
    category: 'Clothes',
  ),
];

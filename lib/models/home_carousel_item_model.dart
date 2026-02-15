// ignore_for_file: public_member_api_docs, sort_constructors_first

class HomeCarouselItemModel {
  final String imgUrl;
  final String id;

  HomeCarouselItemModel({required this.imgUrl, required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'imgUrl': imgUrl, 'id': id};
  }

  factory HomeCarouselItemModel.fromMap(Map<String, dynamic> map) {
    return HomeCarouselItemModel(
      imgUrl: map['imgUrl'] as String,
      id: map['id'] as String,
    );
  }
}

List<HomeCarouselItemModel> dummyHomeCarouselItems = [
  HomeCarouselItemModel(
    id: 'jf385EsSP2RzdIKucgW7',
    imgUrl:
        'https://edit.org/photos/img/blog/mbp-template-banner-online-store-free.jpg-840.jpg',
  ),
  HomeCarouselItemModel(
    id: 'btgMW23JED1zRsxqdKms',
    imgUrl:
        'https://casalsonline.es/wp-content/uploads/2018/12/CASALS-ONLINE-18-DICIEMBRE.png',
  ),
  HomeCarouselItemModel(
    id: 'XjZBor795dLTO2ErQGi3',
    imgUrl:
        'https://e0.pxfuel.com/wallpapers/606/84/desktop-wallpaper-ecommerce-website-design-company-noida-e-commerce-banner-design-e-commerce.jpg',
  ),
  HomeCarouselItemModel(
    id: '8u3jP9mBZYVSGq7JGoc6',
    imgUrl:
        'https://marketplace.canva.com/EAFMdLQAxDU/1/0/1600w/canva-white-and-gray-modern-real-estate-modern-home-banner-NpQukS8X1oo.jpg',
  ),
];

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: 'Welcome to ShopX',
    description: 'Find your favorite products easily',
    image: 'assets/images/corusel_slider_image.webp',
  ),
  OnboardingModel(
    title: 'Exclusive Offers',
    description: 'Get special discounts everyday',
    image: 'assets/images/updated_logo_app.png',
  ),
];

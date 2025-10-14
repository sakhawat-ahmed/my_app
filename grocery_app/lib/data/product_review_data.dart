import 'package:grocery_app/models/product.dart';

class ProductReviewData {
  static List<ProductReview> get sampleReviews => [
    ProductReview(
      id: '1',
      userName: 'John Doe',
      comment: 'Great product! Fresh and delicious. Will definitely buy again.',
      rating: 5,
      date: DateTime(2024, 1, 15),
    ),
    ProductReview(
      id: '2',
      userName: 'Jane Smith',
      comment: 'Good quality, reasonable price. Satisfied with the purchase.',
      rating: 4,
      date: DateTime(2024, 1, 10),
    ),
    ProductReview(
      id: '3',
      userName: 'Mike Johnson',
      comment: 'Product was fresh and delivered on time. Happy with the service.',
      rating: 5,
      date: DateTime(2024, 1, 5),
    ),
    ProductReview(
      id: '4',
      userName: 'Sarah Wilson',
      comment: 'Average quality. Could be better for the price.',
      rating: 3,
      date: DateTime(2024, 1, 2),
    ),
  ];

  static Map<String, String> get productDetails => {
    'Category': 'Fruits',
    'Unit': 'kg',
    'Availability': 'In Stock',
    'Shelf Life': '7-10 days',
    'Storage': 'Refrigerate',
    'Origin': 'Local Farm',
  };
}
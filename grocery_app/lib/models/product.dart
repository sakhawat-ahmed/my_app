class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String unit;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final List<String>? images;
  final Map<String, String>? details;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    this.images,
    this.details,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? unit,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    List<String>? images,
    Map<String, String>? details,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      images: images ?? this.images,
      details: details ?? this.details,
    );
  }
}

class ProductReview {
  final String id;
  final String userName;
  final String comment;
  final int rating;
  final DateTime date;
  final String? userImage;

  const ProductReview({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
    this.userImage,
  });
}

class ProductDetailState {
  final int quantity;
  final bool isFavorite;

  const ProductDetailState({
    this.quantity = 1,
    this.isFavorite = false,
  });

  ProductDetailState copyWith({
    int? quantity,
    bool? isFavorite,
  }) {
    return ProductDetailState(
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
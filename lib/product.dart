// simple class that represent a product
// it has every property a product needs and it includes a useful
// way to parse the received JSON

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnailUrl;

  Product(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.thumbnailUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as double,
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnailUrl: json['image'] as String,
    );
  }
}

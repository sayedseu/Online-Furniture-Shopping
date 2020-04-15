class CartItem {
  final int id;
  final String userID;
  final String productID;
  final String productName;
  final String productPrice;
  final int quantity;
  final String url;

  CartItem(
      {this.id,
      this.userID,
      this.productID,
      this.productName,
      this.productPrice,
      this.quantity,
      this.url});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userID,
      "productId": productID,
      "productName": productName,
      "productPrice": productPrice,
      "quantity": quantity,
      "url": url
    };
  }
}

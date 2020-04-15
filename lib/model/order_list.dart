class OrderList {
  String productID;
  String productName;
  String productPrice;
  int quantity;

  OrderList(
      {this.productID, this.productName, this.productPrice, this.quantity});

  OrderList.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    productName = json['productName'];
    productPrice = json['productPrice'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    data['productName'] = this.productName;
    data['productPrice'] = this.productPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}

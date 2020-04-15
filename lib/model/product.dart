class Product {
  List<String> linkList;
  String productCategory;
  String productDescription;
  String productId;
  String productName;
  String productPrice;

  Product(
      {this.linkList,
      this.productCategory,
      this.productDescription,
      this.productId,
      this.productName,
      this.productPrice});

  Product.fromJson(Map<String, dynamic> json) {
    linkList = json['linkList'].cast<String>();
    productCategory = json['productCategory'];
    productDescription = json['productDescription'];
    productId = json['productId'];
    productName = json['productName'];
    productPrice = json['productPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkList'] = this.linkList;
    data['productCategory'] = this.productCategory;
    data['productDescription'] = this.productDescription;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productPrice'] = this.productPrice;
    return data;
  }
}

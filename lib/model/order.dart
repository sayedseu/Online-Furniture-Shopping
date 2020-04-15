import 'package:furnitureshopping/model/order_list.dart';

class Order {
  String orderDate;
  int orderID;
  List<OrderList> orderList;
  String orderState;
  String totalAmount;
  String userID;

  Order(
      {this.orderDate,
      this.orderID,
      this.orderList,
      this.orderState,
      this.totalAmount,
      this.userID});

  Order.fromJson(Map<String, dynamic> json) {
    orderDate = json['orderDate'];
    orderID = json['orderID'];
    if (json['orderList'] != null) {
      orderList = new List<OrderList>();
      json['orderList'].forEach((v) {
        orderList.add(new OrderList.fromJson(v));
      });
    }
    orderState = json['orderState'];
    totalAmount = json['totalAmount'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDate'] = this.orderDate;
    data['orderID'] = this.orderID;
    if (this.orderList != null) {
      data['orderList'] = this.orderList.map((v) => v.toJson()).toList();
    }
    data['orderState'] = this.orderState;
    data['totalAmount'] = this.totalAmount;
    data['userID'] = this.userID;
    return data;
  }
}

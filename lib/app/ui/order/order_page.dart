import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/model/order.dart';
import 'package:furnitureshopping/model/order_list.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);

    Future<List<Order>> retrieve() async {
      Future<List<Order>> orderList;
      await sessionManager.getUserDetails().then((value) {
        orderList = apiService.retrieveAllOrderById(value.userName);
      });
      return orderList;
    }

    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Order>>(
                future: retrieve(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _allOrder(snapshot.data),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Epty List"),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _allOrder(List<Order> orderList) {
    List<Widget> allWidgets = List<Widget>();
    if (orderList.isNotEmpty) {
      for (Order order in orderList) {
        allWidgets.add(_getOrderUi(order));
      }
    }
    return allWidgets;
  }

  Widget _getOrderUi(Order order) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Order Id: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(order.orderID.toString())
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(order.orderDate)
                ],
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _allItem(order),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Total Amount: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("৳ " + order.totalAmount + "/-",
                  style: TextStyle(color: Colors.deepOrange))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Order State: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(order.orderState)
            ],
          ),
        ),
      ],
    ));
  }

  List<Widget> _allItem(Order order) {
    List<Widget> allWidgets = List<Widget>();
    for (OrderList orderList in order.orderList) {
      allWidgets.add(_getItemUi(orderList));
    }
    return allWidgets;
  }

  Widget _getItemUi(OrderList orderList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(orderList.productName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("‎৳ " + orderList.productPrice + "/-"),
          Text(
            "Q: " + orderList.quantity.toString(),
          )
        ],
      ),
    );
  }
}
